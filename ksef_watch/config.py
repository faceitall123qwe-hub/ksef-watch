import os
import tomllib
from dataclasses import dataclass, field
from pathlib import Path

from ksef2 import Environment

from .notify import Console, Email, Telegram

ENVIRONMENTS = {"production": Environment.PRODUCTION, "demo": Environment.DEMO, "test": Environment.TEST}


@dataclass
class Company:
    name: str
    nip: str
    token: str | None  # None only in the test environment, where a generated certificate is used
    chat_id: str | None = None


@dataclass
class Config:
    environment: Environment
    interval_minutes: int
    remind_days_before: list[int]
    backfill_days: int
    attachment: str  # pdf | html | xml | none
    database: Path
    whitelist_check: bool = True
    companies: list[Company] = field(default_factory=list)
    notifiers: list = field(default_factory=list)


def _secret(section: dict, key: str) -> str:
    env = section.get(f"{key}_env")
    value = os.environ.get(env) if env else section.get(key)
    if not value:
        raise SystemExit(f"Missing secret: set environment variable {env}" if env else f"Missing '{key}' in config")
    return value


def load(path: Path) -> Config:
    raw = tomllib.loads(path.read_text(encoding="utf-8"))
    k = raw.get("ksef", {})
    env_name = k.get("environment", "production")
    cfg = Config(
        environment=ENVIRONMENTS[env_name],
        interval_minutes=int(k.get("interval_minutes", 10)),
        remind_days_before=[int(d) for d in k.get("remind_days_before", [1])],
        backfill_days=int(k.get("backfill_days", 0)),
        attachment=k.get("attachment", "pdf"),
        database=Path(k.get("database", "data/ksef-watch.db")),
        whitelist_check=bool(k.get("whitelist_check", True)),
    )
    for c in raw.get("company", []):
        no_token = not (c.get("token") or c.get("token_env"))
        token = None if env_name == "test" and no_token else _secret(c, "token")
        chat = c.get("telegram_chat_id")
        cfg.companies.append(Company(name=c["name"], nip=str(c["nip"]), token=token,
                                     chat_id=str(chat) if chat else None))
    if not cfg.companies:
        raise SystemExit("Add at least one [[company]] to the config")
    if t := raw.get("telegram"):
        cfg.notifiers.append(Telegram(_secret(t, "bot_token"), str(t.get("chat_id", ""))))
    if e := raw.get("email"):
        cfg.notifiers.append(Email(e["host"], int(e.get("port", 465)), e["user"], _secret(e, "password"),
                                   e.get("from", e["user"]), e["to"]))
    if not cfg.notifiers:
        cfg.notifiers.append(Console())
    return cfg
