"""Checks a seller's bank account against the Ministry of Finance VAT white list (Biała lista VAT).

Paying more than 15 000 PLN to an account that isn't on the list means the expense can't be
deducted and the buyer becomes jointly liable for the seller's VAT, so the check belongs next to
every invoice. The requestId is the proof of the check that accountants keep.
"""
import logging
from dataclasses import dataclass
from datetime import date

import httpx

API = "https://wl-api.mf.gov.pl/api/check/nip/{nip}/bank-account/{account}"
THRESHOLD = 15000

log = logging.getLogger("ksef-watch")


@dataclass(frozen=True)
class Result:
    on_list: bool
    request_id: str
    checked_on: date


def domestic_account(nrb: str) -> str | None:
    digits = nrb.replace(" ", "").upper().removeprefix("PL")
    return digits if len(digits) == 26 and digits.isdigit() else None


def check(seller_nip: str, nrb: str, on: date) -> Result | None:
    account = domestic_account(nrb)
    if not account or not seller_nip:
        return None  # foreign accounts and sellers without a Polish NIP aren't on the list
    try:
        r = httpx.get(API.format(nip=seller_nip, account=account), params={"date": on.isoformat()}, timeout=20)
        r.raise_for_status()
        res = r.json()["result"]
        return Result(on_list=res["accountAssigned"] == "TAK", request_id=res["requestId"], checked_on=on)
    except Exception as e:  # the notification still goes out without this line
        log.warning("white list check failed for %s: %s", seller_nip, e)
        return None


def describe(result: Result | None, gross, currency: str) -> list[str]:
    if result is None:
        return []
    if result.on_list:
        return [f"Biała lista VAT: konto zgodne ({result.checked_on:%d.%m.%Y}, ID {result.request_id})"]
    lines = [f"UWAGA: konta NIE ma na białej liście VAT tego sprzedawcy "
             f"({result.checked_on:%d.%m.%Y}, ID {result.request_id})."]
    if currency == "PLN" and gross >= THRESHOLD:
        lines.append("Przelew powyżej 15 000 zł na to konto nie będzie kosztem i grozi solidarną "
                     "odpowiedzialnością za VAT. Sprawdź numer u sprzedawcy.")
    else:
        lines.append("Sprawdź numer konta u sprzedawcy przed przelewem.")
    return lines
