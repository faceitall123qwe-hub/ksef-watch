# ksef-watch

[![test](https://github.com/faceitall123qwe-hub/ksef-watch/actions/workflows/test.yml/badge.svg)](https://github.com/faceitall123qwe-hub/ksef-watch/actions/workflows/test.yml)

**KSeF nie powiadamia o nowych fakturach.** System nie wysyła e-maili ani SMS-ów, gdy ktoś
wystawi Ci fakturę. Dowiesz się o niej dopiero po zalogowaniu albo gdy kontrahent sam napisze.
ksef-watch sprawdza KSeF co kilka minut i wysyła na Telegram lub e-mail:

```
Nowa faktura kosztowa — Moja Firma

Od: Drukarnia Kowalski (NIP 8562596947)
Kwota: 1 525,20 PLN brutto
Nr faktury: FV/2026/10/77e5
Termin płatności: 06.10.2026 (jutro)
Konto: PL61 1090 1014 0000 0712 1981 2874
UWAGA: konta NIE ma na białej liście VAT tego sprzedawcy (05.10.2026, ID hx6bD-98mm754).
Sprawdź numer konta u sprzedawcy przed przelewem.

KSeF: 8562596947-20261005-A1C168C00000-56
[załącznik: FV_2026_10_77e5.pdf]
```

oraz przypomnienie dzień przed terminem płatności.

- **Biała lista VAT przy każdej fakturze.** Numer konta sprzedawcy jest sprawdzany w API
  Ministerstwa Finansów od razu i ponownie w dniu przypomnienia, bo liczy się stan z dnia przelewu.
  Przy kwocie od 15 000 zł i koncie spoza listy dostajesz wyraźne ostrzeżenie (koszt nie do
  odliczenia, solidarna odpowiedzialność za VAT). Identyfikator zapytania (ID) zostaje w
  wiadomości jako dowód weryfikacji. To też ochrona przed fakturami z podmienionym numerem konta.

- **Działa u Ciebie.** Token KSeF nie opuszcza Twojego serwera, nie ma pośrednika. To ważne, bo
  [CERT Polska ostrzega](https://android.com.pl/tech/1038580-phishing-faktury-ksef-ostrzezenie-cert/)
  przed fałszywymi „powiadomieniami o fakturach z KSeF”.
- **Tylko do odczytu.** Wystarczy token z uprawnieniem „przeglądanie faktur”. Narzędzie niczego
  nie wystawia ani nie zmienia.
- **Wiele NIP-ów.** Biuro rachunkowe dodaje wszystkich klientów; każdy może mieć osobny czat.
- **Faktura w załączniku**: PDF (wizualizacja FA(3)), HTML albo oryginalny XML.
- **Nic nie ginie.** Wiadomość jest zapisywana jako wysłana dopiero, gdy Telegram/poczta ją
  przyjmie; przy awarii wysyłka ponawia się w następnym cyklu.

## Uruchomienie (Docker)

```bash
git clone https://github.com/faceitall123qwe-hub/ksef-watch && cd ksef-watch
cp config.example.toml config.toml   # NIP, nazwa firmy, chat_id
cp .env.example .env                 # token KSeF i token bota
docker compose up -d
docker compose run --rm ksef-watch test-notify -c /config/config.toml   # wiadomość testowa
```

Działa na każdym VPS, Raspberry Pi albo NAS z Dockerem.

### Bez Dockera

```bash
pip install ".[pdf]"     # bez [pdf] załącznikiem będzie HTML
ksef-watch test-notify -c config.toml
ksef-watch run -c config.toml        # albo `once` z crona / Harmonogramu zadań
```

Na Windows PDF wymaga bibliotek GTK (WeasyPrint); bez nich ksef-watch sam wyśle wersję HTML.

## Token KSeF

1. Zaloguj się do Aplikacji Podatnika KSeF (profilem zaufanym, podpisem albo pieczęcią).
2. Tokeny → Generuj token, zaznacz **tylko** „przeglądanie faktur”.
3. Wklej token do `.env` (`KSEF_TOKEN_...`), a nazwę zmiennej do `token_env` w `config.toml`.

## Jak to działa

Co `interval_minutes` ksef-watch loguje się tokenem, pyta o faktury, w których firma jest
nabywcą, po dacie trwałego zapisu w KSeF (z 30-minutowym zakładem, bo KSeF udostępnia fakturę
do wyszukiwania z opóźnieniem około 1–2 minut), pobiera XML nowych, wyciąga sprzedawcę, kwotę,
termin i rachunek, i wysyła powiadomienie. Stan trzyma w SQLite.

Sprawdzone end-to-end na środowisku testowym Ministerstwa Finansów (api-test.ksef.mf.gov.pl):
faktura wystawiona przez innego podatnika trafia na Telegram po około półtorej minuty.
Do komunikacji z KSeF służy [ksef2](https://github.com/stacking-hq/ksef2).

## Wdrożenie dla firmy lub biura rachunkowego

Nie chcesz stawiać serwera? Mogę uruchomić i utrzymywać ksef-watch dla Ciebie:
faceitall123qwe@gmail.com.

---

## English

ksef-watch polls Poland's National e-Invoicing System (KSeF) for **incoming** invoices and sends
a Telegram or e-mail notification with seller, amount, due date, bank account and the invoice as
PDF/HTML/XML, plus a reminder before the payment is due, and checks the seller's bank account against the
Ministry of Finance VAT white list. KSeF itself sends no notifications.
Self-hosted, read-only token, multiple tax IDs, Docker image. MIT licensed.

```bash
python -m pytest -q   # unit tests use a real FA(3) invoice from the KSeF TEST environment
```
