#!/usr/bin/env python3
"""HTML integrity check for the generated report.

Checks: tag balance for the structural tags, no external references
(src/href pointing outside the file), and that the page skeleton is complete.
A checker that cannot fail is worthless, so it reports counts, not just PASS.
"""
import io
import re
import sys
from collections import Counter

path = sys.argv[1]
t = io.open(path, encoding="utf-8", errors="replace").read()

TAGS = ["div", "table", "thead", "tbody", "tr", "td", "th", "pre", "figure",
        "figcaption", "ul", "li", "span", "b", "code", "p", "h1", "h2", "h3", "h4"]
print("bytes: %d" % len(t.encode("utf-8")))
print("\n%-12s %6s %6s %6s" % ("tag", "open", "close", "delta"))
bad = 0
for tag in TAGS:
    o = len(re.findall(r"<%s(?=[\s>/])" % tag, t))
    c = len(re.findall(r"</%s>" % tag, t))
    d = o - c
    if d != 0:
        bad += 1
    print("%-12s %6d %6d %6d%s" % (tag, o, c, d, "   <-- MISMATCH" if d else ""))

print("\n=== references ===")
refs = re.findall(r'(?:src|href)\s*=\s*"([^"]+)"', t)
net = [m for m in refs if m.startswith(('http://', 'https://', '//'))]
data = [m for m in refs if m.startswith('data:')]
anch = [m for m in refs if m.startswith('#')]
local = [m for m in refs if m not in net + data + anch]
print("  network references (must be 0) : %d %s" % (len(net), net[:3]))
print("  inline data: images            : %d" % len(data))
print("  in-page anchors                : %d" % len(anch))
print("  relative file links (optional) : %d %s" % (len(local), sorted(set(local))[:3]))

print("\n=== skeleton ===")
for k in ("<!DOCTYPE html>", "<html lang=\"zh-CN\">", "<style>", "</style>",
          "<body>", "</body>", "</html>", 'class="wrap"', 'class="kpi"', 'class="toc"'):
    print("  %-24s %s" % (k, "OK" if k in t else "MISSING"))

print("\n=== section anchors ===")
for a in re.findall(r'<h2 id="([^"]+)"', t):
    print("  h2 id=%s   (toc link present: %s)" % (a, ('href="#%s"' % a) in t))

print("\nRESULT: %s" % ("PASS" if bad == 0 and not net else "FAIL"))
sys.exit(0 if (bad == 0 and not net) else 1)
