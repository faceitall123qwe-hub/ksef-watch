import argparse
import logging
import sys
import time
from pathlib import Path


def main() -> None:
    p = argparse.ArgumentParser(prog="ksef-watch",
                                description="Powiadomienia o nowych fakturach kosztowych z KSeF.")
    p.add_argument("command", nargs="?", choices=["run", "once", "test-notify", "gui"],
                   help="run: sprawdzaj w pętli · once: jedno sprawdzenie · test-notify: wiadomość testowa · "
                        "gui: okno konfiguracji (Windows)")
    p.add_argument("-c", "--config", default="config.toml", type=Path)
    p.add_argument("--log", type=Path, help="zapisuj log do pliku zamiast na ekran")
    a = p.parse_args()

    if a.command in (None, "gui"):
        if a.command is None and not getattr(sys, "frozen", False):
            p.error("podaj polecenie (run, once, test-notify, gui)")
        from .gui import main as gui
        gui()
        return

    handler = logging.FileHandler(a.log, encoding="utf-8") if a.log else logging.StreamHandler()
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s", handlers=[handler])
    logging.getLogger("httpx").setLevel(logging.WARNING)  # one INFO line per request drowns the log

    from ksef2 import Client

    from .config import load
    from .store import Store
    from .watcher import check_all

    cfg = load(a.config)
    if a.command == "test-notify":
        for n in cfg.notifiers:
            for c in cfg.companies:
                n.send(f"ksef-watch działa — {c.name} (NIP {c.nip}). Tu będą przychodzić nowe faktury.",
                       chat_id=c.chat_id)
        return

    client, store = Client(cfg.environment), Store(cfg.database)
    while True:
        check_all(cfg, client, store)
        if a.command == "once":
            return
        time.sleep(cfg.interval_minutes * 60)


if __name__ == "__main__":
    main()
