from dataclasses import dataclass
from datetime import date, datetime, timedelta, timezone
from decimal import Decimal
from pathlib import Path

import pytest

from ksef_watch import invoice, watcher
from ksef_watch.config import Company, Config
from ksef_watch.store import Store

SAMPLE = (Path(__file__).parent / "fixtures" / "fa3_sample.xml").read_bytes()  # from the KSeF TEST environment
KSEF_NO = "4659611901-20261005-A110E5800000-C1"
NOW = datetime(2026, 10, 5, 21, 0, tzinfo=timezone.utc)


def test_parse_real_fa3():
    inv = invoice.parse(SAMPLE, KSEF_NO)
    assert inv.seller_name == "Hurtownia Testowa Sp. z o.o." and inv.seller_nip == "4659611901"
    assert inv.gross == Decimal("307.50") and inv.currency == "PLN"
    assert inv.due_date == date(2026, 10, 19) and inv.number == "FV/eac39c9a"
    assert inv.bank_account == "PL61109010140000071219812874" and not inv.is_correction


def test_parse_takes_earliest_instalment_and_tolerates_missing_payment():
    xml = SAMPLE.replace(b"<Termin>2026-10-19</Termin>",
                         b"<Termin>2026-11-19</Termin></TerminPlatnosci><TerminPlatnosci><Termin>2026-10-12</Termin>")
    assert invoice.parse(xml, KSEF_NO).due_date == date(2026, 10, 12)
    start, end = SAMPLE.index(b"<Platnosc>"), SAMPLE.index(b"</Platnosc>") + len(b"</Platnosc>")
    bare = invoice.parse(SAMPLE[:start] + SAMPLE[end:], KSEF_NO)
    assert bare.due_date is None and bare.bank_account == ""


def test_formatting():
    assert invoice.money(Decimal("1234567.5"), "PLN") == "1 234 567,50 PLN"
    assert invoice.account("PL61109010140000071219812874") == "PL61 1090 1014 0000 0712 1981 2874"
    assert invoice.account("61109010140000071219812874") == "61 1090 1014 0000 0712 1981 2874"
    msg = invoice.new_invoice_message(invoice.parse(SAMPLE, KSEF_NO), "Moja Firma", date(2026, 10, 5))
    assert "Nowa faktura kosztowa — Moja Firma" in msg
    assert "Kwota: 307,50 PLN brutto" in msg and "Termin płatności: 19.10.2026 (za 14 dni)" in msg


# --- watcher with a fake KSeF ---------------------------------------------------------------

@dataclass
class Meta:
    ksef_number: str
    permanent_storage_date: datetime


class FakeInvoices:
    def __init__(self, metas):
        self.metas, self.downloads, self.filters = metas, [], []

    def all_metadata(self, *, filters):
        self.filters.append(filters)
        return iter(self.metas)

    def download_invoice(self, *, ksef_number):
        self.downloads.append(ksef_number)
        return SAMPLE


class FakeClient:
    def __init__(self, metas):
        self.invoices = FakeInvoices(metas)
        self.authentication = self

    def with_token(self, *, ksef_token, nip):
        return self


class Recorder:
    def __init__(self, fail=False):
        self.sent, self.fail = [], fail

    def send(self, text, attachment=None, chat_id=None):
        if self.fail:
            raise ConnectionError("telegram down")
        self.sent.append((text, attachment, chat_id))


def make(tmp_path, notifier, backfill=0):
    cfg = Config(environment=None, interval_minutes=10, remind_days_before=[1], backfill_days=backfill,
                 attachment="xml", database=tmp_path / "w.db", notifiers=[notifier], whitelist_check=False)
    company = Company(name="Moja Firma", nip="1675877590", token="t", chat_id="42")
    return cfg, company, Store(cfg.database)


def test_first_run_without_backfill_announces_nothing_old(tmp_path):
    rec = Recorder()
    cfg, company, store = make(tmp_path, rec)
    client = FakeClient([Meta(KSEF_NO, NOW - timedelta(minutes=5))])
    assert watcher.check_company(company, cfg, client, store, NOW) == 0
    assert watcher.check_company(company, cfg, client, store, NOW + timedelta(minutes=10)) == 0
    assert rec.sent == []


def test_new_invoice_is_sent_once(tmp_path):
    rec = Recorder()
    cfg, company, store = make(tmp_path, rec)
    store.set_watermark(company.nip, NOW - timedelta(hours=1))
    client = FakeClient([Meta(KSEF_NO, NOW - timedelta(minutes=5))])
    assert watcher.check_company(company, cfg, client, store, NOW) == 1
    assert watcher.check_company(company, cfg, client, store, NOW + timedelta(minutes=10)) == 0
    assert len(rec.sent) == 1 and rec.sent[0][2] == "42"
    assert rec.sent[0][1][0] == "FV_eac39c9a.xml"
    assert client.invoices.downloads == [KSEF_NO]


def test_failed_send_is_retried(tmp_path):
    cfg, company, store = make(tmp_path, Recorder(fail=True))
    store.set_watermark(company.nip, NOW - timedelta(hours=1))
    client = FakeClient([Meta(KSEF_NO, NOW - timedelta(minutes=5))])
    with pytest.raises(ConnectionError):
        watcher.check_company(company, cfg, client, store, NOW)
    rec = Recorder()
    cfg.notifiers = [rec]
    assert watcher.check_company(company, cfg, client, store, NOW) == 1 and len(rec.sent) == 1


def test_query_reaches_back_past_watermark(tmp_path):
    cfg, company, store = make(tmp_path, Recorder())
    client = FakeClient([])
    watcher.check_company(company, cfg, client, store, NOW)
    store.set_watermark(company.nip, NOW)
    watcher.check_company(company, cfg, client, store, NOW + timedelta(minutes=10))
    assert client.invoices.filters[-1].date_from <= NOW - watcher.OVERLAP


def test_reminder_day_before_due_sent_once(tmp_path):
    rec = Recorder()
    cfg, company, store = make(tmp_path, rec)
    store.add(company.nip, invoice.parse(SAMPLE, KSEF_NO))  # due 2026-10-19
    day_before = datetime(2026, 10, 18, 9, 0, tzinfo=timezone.utc)
    client = FakeClient([])
    watcher.check_company(company, cfg, client, store, day_before)
    watcher.check_company(company, cfg, client, store, day_before + timedelta(hours=2))
    reminders = [t for t, _, _ in rec.sent if t.startswith("Termin płatności")]
    assert reminders == [reminders[0]] and "jutro" in reminders[0]


def test_no_separate_reminder_when_new_invoice_is_already_due_tomorrow(tmp_path):
    rec = Recorder()
    cfg, company, store = make(tmp_path, rec)
    day_before = datetime(2026, 10, 18, 9, 0, tzinfo=timezone.utc)
    store.set_watermark(company.nip, day_before - timedelta(hours=1))
    watcher.check_company(company, cfg, FakeClient([Meta(KSEF_NO, day_before)]), store, day_before)
    assert len(rec.sent) == 1 and "(jutro)" in rec.sent[0][0]


# --- VAT white list ----------------------------------------------------------------------------

from ksef_watch import whitelist  # noqa: E402


class FakeResponse:
    def __init__(self, assigned):
        self.assigned = assigned

    def raise_for_status(self):
        pass

    def json(self):
        return {"result": {"accountAssigned": self.assigned, "requestId": "Hd3T6-98mm723"}}


def test_white_list_accounts():
    assert whitelist.domestic_account("PL61 1090 1014 0000 0712 1981 2874") == "61109010140000071219812874"
    assert whitelist.domestic_account("DE89370400440532013000") is None


def test_white_list_check_and_messages(monkeypatch):
    calls = []
    monkeypatch.setattr(whitelist.httpx, "get", lambda url, params, timeout: calls.append((url, params)) or FakeResponse("NIE"))
    res = whitelist.check("4659611901", "PL61109010140000071219812874", date(2026, 10, 5))
    assert calls[0][0].endswith("/nip/4659611901/bank-account/61109010140000071219812874")
    assert calls[0][1] == {"date": "2026-10-05"}
    big = whitelist.describe(res, Decimal("20000"), "PLN")
    assert big[0].startswith("UWAGA: konta NIE ma") and "15 000 zł" in big[1]
    small = whitelist.describe(res, Decimal("307.50"), "PLN")
    assert "15 000" not in small[1]
    ok = whitelist.describe(whitelist.Result(True, "abc", date(2026, 10, 5)), Decimal("1"), "PLN")
    assert ok == ["Biała lista VAT: konto zgodne (05.10.2026, ID abc)"]


def test_white_list_failure_does_not_block_notification(monkeypatch):
    def boom(*a, **k):
        raise ConnectionError("mf down")
    monkeypatch.setattr(whitelist.httpx, "get", boom)
    assert whitelist.check("4659611901", "PL61109010140000071219812874", date(2026, 10, 5)) is None
    assert whitelist.describe(None, Decimal("1"), "PLN") == []


def test_white_list_line_in_new_invoice_message(tmp_path, monkeypatch):
    monkeypatch.setattr(whitelist.httpx, "get", lambda url, params, timeout: FakeResponse("TAK"))
    rec = Recorder()
    cfg, company, store = make(tmp_path, rec)
    cfg.whitelist_check = True
    store.set_watermark(company.nip, NOW - timedelta(hours=1))
    watcher.check_company(company, cfg, FakeClient([Meta(KSEF_NO, NOW - timedelta(minutes=5))]), store, NOW)
    assert "Biała lista VAT: konto zgodne" in rec.sent[0][0]
