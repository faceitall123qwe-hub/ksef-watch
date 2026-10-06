"""Setup window for the Windows build: companies, Telegram, test message, background schedule."""
import json
import os
import subprocess
import sys
import threading
import tkinter as tk
import tomllib
from pathlib import Path
from tkinter import messagebox, ttk

import httpx

from .config import KEYRING_SERVICE

APP_DIR = Path(os.environ.get("APPDATA", Path.home())) / "ksef-watch"
CONFIG = APP_DIR / "config.toml"
LOG = APP_DIR / "ksef-watch.log"
TASK = "ksef-watch"
ENVS = {"Produkcja": "production", "Demo": "demo", "Test (MF)": "test"}


def valid_nip(nip: str) -> bool:
    if len(nip) != 10 or not nip.isdigit():
        return False
    check = sum(int(d) * w for d, w in zip(nip, (6, 5, 7, 2, 3, 4, 5, 6, 7))) % 11
    return check == int(nip[9])


def _set_secret(name: str, value: str) -> None:
    import keyring
    keyring.set_password(KEYRING_SERVICE, name, value)


def _q(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)  # a JSON string is a valid TOML basic string


def write_config(env: str, interval: int, companies: list[dict], chat_id: str) -> None:
    APP_DIR.mkdir(parents=True, exist_ok=True)
    out = [
        "[ksef]",
        f"environment = {_q(env)}",
        f"interval_minutes = {interval}",
        "remind_days_before = [1]",
        'attachment = "pdf"',
        "whitelist_check = true",
        f"database = {_q(str(APP_DIR / 'ksef-watch.db'))}",
        "",
    ]
    for c in companies:
        out += ["[[company]]", f"name = {_q(c['name'])}", f"nip = {_q(c['nip'])}"]
        if c.get("has_token"):
            out.append(f"token_keyring = {_q('token-' + c['nip'])}")
        if c.get("chat_id"):
            out.append(f"telegram_chat_id = {_q(c['chat_id'])}")
        out.append("")
    out += ["[telegram]", 'bot_token_keyring = "telegram-bot"', f"chat_id = {_q(chat_id)}", ""]
    CONFIG.write_text("\n".join(out), encoding="utf-8")


def read_config() -> tuple[str, int, list[dict], str]:
    if not CONFIG.exists():
        return "production", 10, [], ""
    raw = tomllib.loads(CONFIG.read_text(encoding="utf-8"))
    k = raw.get("ksef", {})
    companies = [{"name": c["name"], "nip": c["nip"], "has_token": "token_keyring" in c,
                  "chat_id": c.get("telegram_chat_id", "")} for c in raw.get("company", [])]
    return k.get("environment", "production"), int(k.get("interval_minutes", 10)), companies, \
        str(raw.get("telegram", {}).get("chat_id", ""))


def scheduled_command() -> list[str]:
    if getattr(sys, "frozen", False):
        return [sys.executable, "once", "-c", str(CONFIG), "--log", str(LOG)]
    pythonw = Path(sys.executable).with_name("pythonw.exe")
    return [str(pythonw if pythonw.exists() else sys.executable), "-m", "ksef_watch",
            "once", "-c", str(CONFIG), "--log", str(LOG)]


def schedule(minutes: int) -> None:
    command = subprocess.list2cmdline(scheduled_command())
    subprocess.run(["schtasks", "/Create", "/TN", TASK, "/TR", command, "/SC", "MINUTE", "/MO", str(minutes), "/F"],
                   check=True, capture_output=True, creationflags=subprocess.CREATE_NO_WINDOW)


def unschedule() -> None:
    subprocess.run(["schtasks", "/Delete", "/TN", TASK, "/F"], capture_output=True,
                   creationflags=subprocess.CREATE_NO_WINDOW)


def is_scheduled() -> bool:
    r = subprocess.run(["schtasks", "/Query", "/TN", TASK], capture_output=True,
                       creationflags=subprocess.CREATE_NO_WINDOW)
    return r.returncode == 0


class CompanyDialog(tk.Toplevel):
    def __init__(self, parent):
        super().__init__(parent)
        self.title("Dodaj firmę")
        self.resizable(False, False)
        self.result = None
        self.vars = {k: tk.StringVar() for k in ("name", "nip", "token", "chat_id")}
        rows = [("Nazwa firmy", "name", False), ("NIP", "nip", False), ("Token KSeF", "token", True),
                ("Czat Telegram (opcjonalnie)", "chat_id", False)]
        for i, (label, key, secret) in enumerate(rows):
            ttk.Label(self, text=label).grid(row=i, column=0, sticky="w", padx=10, pady=4)
            ttk.Entry(self, textvariable=self.vars[key], width=46, show="•" if secret else "").grid(
                row=i, column=1, padx=10, pady=4)
        ttk.Label(self, text="Token wygeneruj w Aplikacji Podatnika KSeF z uprawnieniem tylko\n"
                             "„przeglądanie faktur”. W środowisku testowym token nie jest potrzebny.",
                  foreground="#555").grid(row=4, column=0, columnspan=2, padx=10, pady=(4, 8), sticky="w")
        ttk.Button(self, text="Zapisz", command=self.save).grid(row=5, column=1, sticky="e", padx=10, pady=10)
        self.transient(parent)
        self.grab_set()

    def save(self):
        v = {k: var.get().strip() for k, var in self.vars.items()}
        v["nip"] = v["nip"].replace("-", "").replace(" ", "")
        if not v["name"] or not valid_nip(v["nip"]):
            messagebox.showerror("ksef-watch", "Podaj nazwę i poprawny NIP (10 cyfr).", parent=self)
            return
        if v["token"]:
            _set_secret("token-" + v["nip"], v["token"])
        self.result = {"name": v["name"], "nip": v["nip"], "has_token": bool(v["token"]), "chat_id": v["chat_id"]}
        self.destroy()


class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("ksef-watch — powiadomienia o fakturach z KSeF")
        self.resizable(False, False)
        env, interval, self.companies, chat_id = read_config()
        self.env = tk.StringVar(value=next((k for k, v in ENVS.items() if v == env), "Produkcja"))
        self.interval = tk.StringVar(value=str(interval))
        self.bot = tk.StringVar()
        self.chat = tk.StringVar(value=chat_id)
        self.status = tk.StringVar()

        pad = {"padx": 12, "pady": 6}
        box = ttk.LabelFrame(self, text="Firmy (NIP)")
        box.grid(row=0, column=0, columnspan=3, sticky="we", **pad)
        self.list = tk.Listbox(box, height=6, width=64)
        self.list.grid(row=0, column=0, rowspan=2, padx=8, pady=8)
        ttk.Button(box, text="Dodaj…", command=self.add).grid(row=0, column=1, padx=8, sticky="n", pady=8)
        ttk.Button(box, text="Usuń", command=self.remove).grid(row=1, column=1, padx=8, sticky="n")

        tg = ttk.LabelFrame(self, text="Telegram")
        tg.grid(row=1, column=0, columnspan=3, sticky="we", **pad)
        ttk.Label(tg, text="Token bota (@BotFather)").grid(row=0, column=0, sticky="w", padx=8, pady=4)
        ttk.Entry(tg, textvariable=self.bot, width=44, show="•").grid(row=0, column=1, padx=8, pady=4)
        ttk.Label(tg, text="ID czatu").grid(row=1, column=0, sticky="w", padx=8, pady=4)
        ttk.Entry(tg, textvariable=self.chat, width=44).grid(row=1, column=1, padx=8, pady=4)
        ttk.Button(tg, text="Wykryj", command=self.detect_chat).grid(row=1, column=2, padx=8)
        ttk.Label(tg, text="Zostaw token pusty, jeśli jest już zapisany.", foreground="#555").grid(
            row=2, column=1, sticky="w", padx=8)

        opts = ttk.Frame(self)
        opts.grid(row=2, column=0, columnspan=3, sticky="we", **pad)
        ttk.Label(opts, text="Środowisko").pack(side="left")
        ttk.Combobox(opts, textvariable=self.env, values=list(ENVS), width=12, state="readonly").pack(
            side="left", padx=(6, 18))
        ttk.Label(opts, text="Sprawdzaj co (min)").pack(side="left")
        ttk.Spinbox(opts, from_=5, to=120, textvariable=self.interval, width=5).pack(side="left", padx=6)

        btns = ttk.Frame(self)
        btns.grid(row=3, column=0, columnspan=3, sticky="we", **pad)
        ttk.Button(btns, text="Wyślij test", command=lambda: self.run_async(self.test)).pack(side="left")
        ttk.Button(btns, text="Sprawdź teraz", command=lambda: self.run_async(self.check_now)).pack(
            side="left", padx=6)
        ttk.Button(btns, text="Wyłącz", command=self.stop).pack(side="right")
        ttk.Button(btns, text="Zapisz i uruchamiaj w tle", command=self.start).pack(side="right", padx=6)
        ttk.Label(self, textvariable=self.status, foreground="#1a5d1a", wraplength=520).grid(
            row=4, column=0, columnspan=3, sticky="w", padx=12, pady=(0, 12))
        self.refresh()
        self.status.set("Działa w tle." if is_scheduled() else "Nie działa w tle.")

    def refresh(self):
        self.list.delete(0, "end")
        for c in self.companies:
            self.list.insert("end", f"{c['name']}  ·  NIP {c['nip']}" + ("" if c["has_token"] else "  (bez tokenu)"))

    def add(self):
        d = CompanyDialog(self)
        self.wait_window(d)
        if d.result:
            self.companies = [c for c in self.companies if c["nip"] != d.result["nip"]] + [d.result]
            self.refresh()

    def remove(self):
        if sel := self.list.curselection():
            del self.companies[sel[0]]
            self.refresh()

    def detect_chat(self):
        token = self.bot.get().strip() or self._saved_bot()
        if not token:
            messagebox.showinfo("ksef-watch", "Najpierw wpisz token bota.")
            return
        try:
            updates = httpx.get(f"https://api.telegram.org/bot{token}/getUpdates", timeout=20).json()["result"]
            chats = [u[k]["chat"]["id"] for u in updates for k in ("message", "channel_post", "my_chat_member") if k in u]
        except Exception as e:
            messagebox.showerror("ksef-watch", f"Nie udało się połączyć z Telegramem: {e}")
            return
        if not chats:
            messagebox.showinfo("ksef-watch", "Napisz dowolną wiadomość do swojego bota i kliknij „Wykryj” ponownie.")
            return
        self.chat.set(str(chats[-1]))

    @staticmethod
    def _saved_bot() -> str | None:
        import keyring
        return keyring.get_password(KEYRING_SERVICE, "telegram-bot")

    def save(self) -> bool:
        if not self.companies:
            messagebox.showerror("ksef-watch", "Dodaj co najmniej jedną firmę.")
            return False
        if self.bot.get().strip():
            _set_secret("telegram-bot", self.bot.get().strip())
        if not self._saved_bot() or not self.chat.get().strip():
            messagebox.showerror("ksef-watch", "Podaj token bota i ID czatu Telegram.")
            return False
        write_config(ENVS[self.env.get()], max(5, int(self.interval.get() or 10)), self.companies, self.chat.get().strip())
        return True

    def run_async(self, fn):
        if self.save():
            self.status.set("Pracuję…")
            threading.Thread(target=self._guard, args=(fn,), daemon=True).start()

    def _guard(self, fn):
        try:
            msg = fn()
        except BaseException as e:  # SystemExit from config errors included
            msg = f"Błąd: {e}"
        self.after(0, self.status.set, msg)

    def test(self) -> str:
        from .config import load
        cfg = load(CONFIG)
        for n in cfg.notifiers:
            for c in cfg.companies:
                n.send(f"ksef-watch działa — {c.name} (NIP {c.nip}). Tu będą przychodzić nowe faktury.",
                       chat_id=c.chat_id)
        return "Wiadomość testowa wysłana. Sprawdź Telegram."

    def check_now(self) -> str:
        from ksef2 import Client
        from .config import load
        from .store import Store
        from .watcher import check_company
        cfg = load(CONFIG)
        client, store = Client(cfg.environment), Store(cfg.database)
        parts = [f"{c.name}: {check_company(c, cfg, client, store)} nowych" for c in cfg.companies]
        return "Sprawdzone. " + ", ".join(parts)

    def start(self):
        if self.save():
            try:
                schedule(int(self.interval.get()))
                self.status.set(f"Działa w tle co {self.interval.get()} min, także po restarcie komputera "
                                f"(gdy jesteś zalogowany). Log: {LOG}")
            except subprocess.CalledProcessError as e:
                self.status.set(f"Nie udało się utworzyć zadania: {e.stderr.decode(errors='ignore')}")

    def stop(self):
        unschedule()
        self.status.set("Wyłączone.")


def main():
    try:  # without this Windows bitmap-scales the window on laptops and it looks blurry
        import ctypes
        ctypes.windll.shcore.SetProcessDpiAwareness(1)
    except Exception:
        pass
    App().mainloop()
