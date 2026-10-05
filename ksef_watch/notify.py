import smtplib
from email.message import EmailMessage

import httpx

Attachment = tuple[str, bytes]


class Telegram:
    def __init__(self, bot_token: str, chat_id: str):
        self.url = f"https://api.telegram.org/bot{bot_token}"
        self.chat_id = chat_id

    def send(self, text: str, attachment: Attachment | None = None, chat_id: str | None = None) -> None:
        chat = chat_id or self.chat_id
        if attachment:
            name, data = attachment
            r = httpx.post(f"{self.url}/sendDocument", data={"chat_id": chat, "caption": text[:1024]},
                           files={"document": (name, data)}, timeout=60)
        else:
            r = httpx.post(f"{self.url}/sendMessage", json={"chat_id": chat, "text": text}, timeout=30)
        r.raise_for_status()


class Email:
    def __init__(self, host: str, port: int, user: str, password: str, sender: str, to: str):
        self.host, self.port, self.user, self.password = host, port, user, password
        self.sender, self.to = sender, to

    def send(self, text: str, attachment: Attachment | None = None, chat_id: str | None = None) -> None:
        msg = EmailMessage()
        msg["Subject"] = text.splitlines()[0]
        msg["From"], msg["To"] = self.sender, self.to
        msg.set_content(text)
        if attachment:
            name, data = attachment
            maintype, subtype = {"pdf": ("application", "pdf"), "html": ("text", "html")}.get(
                name.rsplit(".", 1)[-1], ("application", "xml"))
            msg.add_attachment(data, maintype=maintype, subtype=subtype, filename=name)
        with smtplib.SMTP_SSL(self.host, self.port, timeout=30) as s:
            s.login(self.user, self.password)
            s.send_message(msg)


class Console:
    """Prints instead of sending, for trying the setup before creating a bot."""

    def send(self, text: str, attachment: Attachment | None = None, chat_id: str | None = None) -> None:
        extra = f"\n[załącznik: {attachment[0]}, {len(attachment[1])} B]" if attachment else ""
        print(f"{text}{extra}\n", flush=True)
