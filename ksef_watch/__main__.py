import argparse
import logging
import time
from pathlib import Path

from ksef2 import Client

from .config import load
from .store import Store
from .watcher import check_all


def main() -> None:
    p = argparse.ArgumentParser(prog="ksef-watch",
                                description="Powiadomienia o nowych fakturach kosztowych z KSeF.")
    p.add_argument("command", choices=["run", "once", "test-notify"],
                   help="run: sprawdzaj w pętli · once: jedno sprawdzenie · test-notify: wyślij wiadomość testową")
    p.add_argument("-c", "--config", default="config.toml", type=Path)
    a = p.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
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
