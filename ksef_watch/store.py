import sqlite3
from datetime import date, datetime, timedelta
from decimal import Decimal
from pathlib import Path

from .invoice import Invoice

_COLUMNS = "ksef_number, number, seller_name, seller_nip, gross, currency, due_date, bank_account, is_correction"


class Store:
    def __init__(self, path: Path):
        path.parent.mkdir(parents=True, exist_ok=True)
        self.db = sqlite3.connect(path)
        self.db.executescript("""
            CREATE TABLE IF NOT EXISTS invoices (
                nip TEXT NOT NULL,
                ksef_number TEXT NOT NULL,
                number TEXT, seller_name TEXT, seller_nip TEXT,
                gross TEXT, currency TEXT, due_date TEXT, bank_account TEXT,
                is_correction INTEGER NOT NULL DEFAULT 0,
                seen_at TEXT NOT NULL DEFAULT (datetime('now')),
                reminded_on TEXT,
                PRIMARY KEY (nip, ksef_number)
            );
            CREATE TABLE IF NOT EXISTS watermark (nip TEXT PRIMARY KEY, value TEXT NOT NULL);
        """)

    def watermark(self, nip: str) -> datetime | None:
        row = self.db.execute("SELECT value FROM watermark WHERE nip = ?", (nip,)).fetchone()
        return datetime.fromisoformat(row[0]) if row else None

    def set_watermark(self, nip: str, value: datetime) -> None:
        self.db.execute(
            "INSERT INTO watermark VALUES (?, ?) ON CONFLICT(nip) DO UPDATE SET value = excluded.value",
            (nip, value.isoformat()))
        self.db.commit()

    def seen(self, nip: str, ksef_number: str) -> bool:
        return self.db.execute("SELECT 1 FROM invoices WHERE nip = ? AND ksef_number = ?",
                               (nip, ksef_number)).fetchone() is not None

    def mark_seen(self, nip: str, ksef_number: str) -> None:
        self.db.execute("INSERT OR IGNORE INTO invoices (nip, ksef_number) VALUES (?, ?)", (nip, ksef_number))
        self.db.commit()

    def add(self, nip: str, inv: Invoice) -> None:
        self.db.execute(
            f"INSERT OR IGNORE INTO invoices (nip, {_COLUMNS}) VALUES (?,?,?,?,?,?,?,?,?,?)",
            (nip, inv.ksef_number, inv.number, inv.seller_name, inv.seller_nip, str(inv.gross), inv.currency,
             inv.due_date.isoformat() if inv.due_date else None, inv.bank_account, int(inv.is_correction)))
        self.db.commit()

    def due_for_reminder(self, nip: str, today: date, days_before: list[int]) -> list[Invoice]:
        targets = [(today + timedelta(days=d)).isoformat() for d in days_before]
        marks = ",".join("?" * len(targets))
        rows = self.db.execute(
            f"SELECT {_COLUMNS} FROM invoices WHERE nip = ? AND reminded_on IS NULL AND due_date IN ({marks})",
            (nip, *targets)).fetchall()
        return [Invoice(ksef_number=r[0], number=r[1], seller_name=r[2], seller_nip=r[3], gross=Decimal(r[4]),
                        currency=r[5], issue_date=None, due_date=date.fromisoformat(r[6]), bank_account=r[7],
                        is_correction=bool(r[8])) for r in rows]

    def mark_reminded(self, nip: str, ksef_number: str, today: date) -> None:
        self.db.execute("UPDATE invoices SET reminded_on = ? WHERE nip = ? AND ksef_number = ?",
                        (today.isoformat(), nip, ksef_number))
        self.db.commit()
