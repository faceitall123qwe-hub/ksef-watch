import logging
from datetime import datetime, timedelta, timezone

from ksef2 import Client
from ksef2.models import InvoicesFilter

from . import invoice, whitelist
from .config import Company, Config
from .store import Store

log = logging.getLogger("ksef-watch")

# KSeF makes an invoice queryable a minute or two after its permanent-storage timestamp, so each
# query reaches back past the watermark; duplicates are dropped by the store.
OVERLAP = timedelta(minutes=30)


def render(xml: bytes, kind: str, number: str) -> tuple[str, bytes] | None:
    safe = "".join(ch if ch.isalnum() or ch in "-_" else "_" for ch in number) or "faktura"
    if kind == "pdf":
        try:
            from ksef2.renderers import InvoicePDFExporter
            return f"{safe}.pdf", InvoicePDFExporter().export_from_string(xml)
        except Exception as e:  # WeasyPrint needs Pango; without it fall back to HTML
            log.warning("PDF rendering unavailable (%s), sending HTML instead", type(e).__name__)
            kind = "html"
    if kind == "html":
        from ksef2.renderers import InvoiceXSLTRenderer
        return f"{safe}.html", InvoiceXSLTRenderer().render_from_string(xml).encode("utf-8")
    if kind == "xml":
        return f"{safe}.xml", xml
    return None


def white_list(inv: invoice.Invoice, cfg: Config, today) -> list[str]:
    if not cfg.whitelist_check or not inv.bank_account:
        return []
    return whitelist.describe(whitelist.check(inv.seller_nip, inv.bank_account, today), inv.gross, inv.currency)


def authenticate(client: Client, company: Company):
    if company.token is None:
        return client.authentication.with_test_certificate(nip=company.nip)
    return client.authentication.with_token(ksef_token=company.token, nip=company.nip)


def check_company(company: Company, cfg: Config, client: Client, store: Store,
                  now: datetime | None = None) -> int:
    now = now or datetime.now(timezone.utc)
    today = now.astimezone().date()
    watermark = store.watermark(company.nip)
    first_run = watermark is None
    if first_run:
        watermark = now - timedelta(days=cfg.backfill_days)
        store.set_watermark(company.nip, watermark)

    auth = authenticate(client, company)
    found = list(auth.invoices.all_metadata(filters=InvoicesFilter.for_buyer(
        date_from=watermark - OVERLAP, date_to=now, date_type="permanent_storage")))
    if first_run and cfg.backfill_days == 0:
        # Without a backfill only invoices arriving from now on are news; the overlap window
        # would otherwise announce the last half hour on the very first start.
        for meta in found:
            store.mark_seen(company.nip, meta.ksef_number)
        return 0
    new = 0
    for meta in sorted(found, key=lambda m: m.permanent_storage_date):
        if store.seen(company.nip, meta.ksef_number):
            continue
        xml = auth.invoices.download_invoice(ksef_number=meta.ksef_number)
        inv = invoice.parse(xml, meta.ksef_number)
        text = invoice.new_invoice_message(inv, company.name, today, white_list(inv, cfg, today))
        attachment = render(xml, cfg.attachment, inv.number)
        for n in cfg.notifiers:
            n.send(text, attachment, chat_id=company.chat_id)
        store.add(company.nip, inv)  # only after sending, so a failed send is retried next round
        if inv.due_date and (inv.due_date - today).days in cfg.remind_days_before:
            store.mark_reminded(company.nip, inv.ksef_number, today)  # the message above already says it
        watermark = max(watermark, meta.permanent_storage_date)
        new += 1
    store.set_watermark(company.nip, watermark)

    for inv in store.due_for_reminder(company.nip, today, cfg.remind_days_before):
        for n in cfg.notifiers:
            # Checked again: what counts is the account's status on the day of payment.
            text = invoice.reminder_message(inv, company.name, today, white_list(inv, cfg, today))
            n.send(text, chat_id=company.chat_id)
        store.mark_reminded(company.nip, inv.ksef_number, today)
    return new


def check_all(cfg: Config, client: Client, store: Store) -> None:
    for company in cfg.companies:
        try:
            n = check_company(company, cfg, client, store)
            log.info("%s (%s): %d new", company.name, company.nip, n)
        except Exception:
            # One company with an expired token must not stop the others.
            log.exception("%s (%s): check failed", company.name, company.nip)
