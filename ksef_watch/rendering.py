"""Turns an FA(3) XML into the attachment sent with a notification."""
import logging
import os
import shutil
import subprocess
import tempfile
from pathlib import Path

log = logging.getLogger("ksef-watch")

EDGE_PATHS = [
    Path(os.environ.get("PROGRAMFILES(X86)", r"C:\Program Files (x86)")) / "Microsoft/Edge/Application/msedge.exe",
    Path(os.environ.get("PROGRAMFILES", r"C:\Program Files")) / "Microsoft/Edge/Application/msedge.exe",
]


def html(xml: bytes) -> bytes:
    from ksef2.renderers import InvoiceXSLTRenderer
    return InvoiceXSLTRenderer().render_from_string(xml).encode("utf-8")


def _weasyprint_pdf(xml: bytes) -> bytes:
    from ksef2.renderers import InvoicePDFExporter
    return InvoicePDFExporter().export_from_string(xml)


def _edge_pdf(xml: bytes) -> bytes:
    """Every Windows has Edge, while WeasyPrint there needs GTK, so desktop installs print with it."""
    edge = next((p for p in EDGE_PATHS if p.exists()), None) or shutil.which("msedge")
    if not edge:
        raise FileNotFoundError("Microsoft Edge not found")
    with tempfile.TemporaryDirectory() as tmp:
        src, out = Path(tmp) / "invoice.html", Path(tmp) / "invoice.pdf"
        src.write_bytes(html(xml))
        # A separate profile keeps this from attaching to the user's open Edge window.
        subprocess.run([str(edge), "--headless=new", "--disable-gpu", "--no-pdf-header-footer",
                        f"--user-data-dir={Path(tmp) / 'profile'}", f"--print-to-pdf={out}", src.as_uri()],
                       capture_output=True, timeout=60, creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        if not out.exists() or out.read_bytes()[:5] != b"%PDF-":
            raise RuntimeError("Edge did not produce a PDF")
        return out.read_bytes()


def attachment(xml: bytes, kind: str, number: str) -> tuple[str, bytes] | None:
    safe = "".join(ch if ch.isalnum() or ch in "-_" else "_" for ch in number) or "faktura"
    if kind == "pdf":
        makers = (_edge_pdf, _weasyprint_pdf) if os.name == "nt" else (_weasyprint_pdf, _edge_pdf)
        for make in makers:
            try:
                return f"{safe}.pdf", make(xml)
            except Exception as e:
                log.debug("%s unavailable: %s", make.__name__, e)
        log.warning("No PDF renderer available, sending HTML instead")
        kind = "html"
    if kind == "html":
        return f"{safe}.html", html(xml)
    if kind == "xml":
        return f"{safe}.xml", xml
    return None
