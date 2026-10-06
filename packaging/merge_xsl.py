"""Builds docs/faktura/fa3.xsl: the Ministry of Finance FA(3) visualisation stylesheet with its
xsl:import inlined, because browsers' XSLTProcessor can't follow imports reliably.

Imported templates have lower precedence, so a template is copied from the imported file only
when the main stylesheet doesn't define one with the same name or match."""
import sys
from pathlib import Path

from lxml import etree

XSL = "http://www.w3.org/1999/XSL/Transform"
src = Path(sys.argv[1])  # directory with styl.xsl and the imported common templates
main = etree.parse(str(src / "styl.xsl"))
root = main.getroot()
imp = root.find(f"{{{XSL}}}import")
lib = etree.parse(str(src / imp.get("href"))).getroot()
root.remove(imp)


def key(el):
    return (etree.QName(el).localname, el.get("name"), el.get("match"), el.get("mode"))


own = {key(el) for el in root if isinstance(el.tag, str)}
skip = {"output"}  # the main file's output settings win
insert_at = 0
for el in lib:
    if not isinstance(el.tag, str) or etree.QName(el).localname in skip or key(el) in own:
        continue
    root.insert(insert_at, el)
    insert_at += 1
# Prefixes like tns: are used only inside XPath attributes, so the root is rebuilt with both
# files' declarations rather than relying on lxml's namespace cleanup (which would drop them).
merged = etree.Element(root.tag, attrib=dict(root.attrib), nsmap={**lib.nsmap, **root.nsmap})
merged.extend(list(root))
main._setroot(merged)
root = merged

# Code descriptions come from schema files on crd.gov.pl via document(); a browser can't fetch
# them cross-origin, so the page renders codes as they are (same as ksef2's default).
for p in root.iter(f"{{{XSL}}}param"):
    if p.get("name") == "nazwy-dla-kodow":
        p.set("select", "false()")
        for child in list(p):
            p.remove(child)
        p.text = None

out = Path(sys.argv[2])
out.write_bytes(etree.tostring(main, xml_declaration=True, encoding="UTF-8"))
print(f"{out}: {out.stat().st_size} bytes, {insert_at} templates inlined")
