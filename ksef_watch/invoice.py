"""Pulls the fields a buyer cares about out of an FA(3) invoice XML and formats the messages."""
from dataclasses import dataclass
from datetime import date
from decimal import Decimal
from xml.etree import ElementTree as ET


@dataclass(frozen=True)
class Invoice:
    ksef_number: str
    number: str
    seller_name: str
    seller_nip: str
    gross: Decimal
    currency: str
    issue_date: date | None
    due_date: date | None
    bank_account: str
    is_correction: bool


def _q(path: str) -> str:
    # FA(3) namespaces change with every schema revision, so match on local names only.
    return "/".join(f"{{*}}{part}" for part in path.split("/"))


def _text(root, path: str) -> str:
    el = root.find(_q(path))
    return el.text.strip() if el is not None and el.text else ""


def _date(value: str) -> date | None:
    try:
        return date.fromisoformat(value[:10]) if value else None
    except ValueError:
        return None


def parse(xml: bytes, ksef_number: str) -> Invoice:
    root = ET.fromstring(xml)
    due = [d for d in (_date((e.text or "").strip()) for e in root.findall(_q("Fa/Platnosc/TerminPlatnosci/Termin"))) if d]
    return Invoice(
        ksef_number=ksef_number,
        number=_text(root, "Fa/P_2"),
        seller_name=_text(root, "Podmiot1/DaneIdentyfikacyjne/Nazwa"),
        seller_nip=_text(root, "Podmiot1/DaneIdentyfikacyjne/NIP"),
        gross=Decimal(_text(root, "Fa/P_15") or "0"),
        currency=_text(root, "Fa/KodWaluty") or "PLN",
        issue_date=_date(_text(root, "Fa/P_1")),
        # Instalments are allowed; the earliest one is what needs paying first.
        due_date=min(due) if due else None,
        bank_account=_text(root, "Fa/Platnosc/RachunekBankowy/NrRB"),
        is_correction=_text(root, "Fa/RodzajFaktury").startswith("KOR"),
    )


def money(amount: Decimal, currency: str) -> str:
    whole, _, frac = f"{amount:,.2f}".partition(".")
    return f"{whole.replace(',', ' ')},{frac} {currency}"


def account(nrb: str) -> str:
    """PL61109010140000071219812874 -> PL61 1090 1014 0000 0712 1981 2874"""
    s = nrb.replace(" ", "")
    head, rest = (s[:4], s[4:]) if s[:2].isalpha() else (s[:2], s[2:])
    return " ".join([head] + [rest[i:i + 4] for i in range(0, len(rest), 4)])


def _when(days: int) -> str:
    if days == 0:
        return "dziś"
    if days == 1:
        return "jutro"
    return f"za {days} dni" if days > 1 else f"{-days} dni po terminie"


def new_invoice_message(inv: Invoice, company: str, today: date) -> str:
    lines = [
        f"{'Nowa korekta faktury' if inv.is_correction else 'Nowa faktura kosztowa'} — {company}",
        "",
        f"Od: {inv.seller_name} (NIP {inv.seller_nip})",
        f"Kwota: {money(inv.gross, inv.currency)} brutto",
        f"Nr faktury: {inv.number}",
    ]
    if inv.due_date:
        lines.append(f"Termin płatności: {inv.due_date:%d.%m.%Y} ({_when((inv.due_date - today).days)})")
    if inv.bank_account:
        lines.append(f"Konto: {account(inv.bank_account)}")
    lines += ["", f"KSeF: {inv.ksef_number}"]
    return "\n".join(lines)


def reminder_message(inv: Invoice, company: str, today: date) -> str:
    lines = [
        f"Termin płatności {_when((inv.due_date - today).days)} — {company}",
        "",
        f"{inv.seller_name}: {money(inv.gross, inv.currency)}",
        f"Nr faktury: {inv.number}",
    ]
    if inv.bank_account:
        lines.append(f"Konto: {account(inv.bank_account)}")
    return "\n".join(lines)
