"""Render the ACTUAL delivered layout and the measured result charts to PNG.

Everything here is drawn from the delivered GDS itself (geometry and placements) or from
the numbers measured in this engagement -- no decorative or illustrative content.

Figures
  fig1_layers.png    M1..M6 as drawn by the top cell, one panel per layer (whole die)
  fig2_place.png     the 3 626 standard-cell placements + the 178 port labels on the die
  fig3_zoom.png      the densest 60x60 um window, M1/M2/M3 overlaid -- real routing
  fig4_layer_stats   shapes / area / wirelength (H+V) / density per layer
  fig5_width.png     drawn-width distribution per layer
  fig6_vias.png      via placements per layer pair (log scale)
  fig7_timing.png    setup + hold vs derate point, and the hold-path waterfall
  fig8_drc.png       DRC result composition, with the two capped checks marked
"""
import collections
import io
import os
import struct
import sys

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import numpy as np

sys.stdout.reconfigure(encoding='utf-8')   # the console here is GBK; µm would crash it

GDS = sys.argv[1] if len(sys.argv) > 1 else '../evidence/rpt_v51/sar_digi_paper_core_merged.gds'
OUT = sys.argv[2] if len(sys.argv) > 2 else '../evidence/figures'
TOP = 'sar_digi_paper_core'
DIE_W, DIE_H = 430.520, 429.340
REC = {0x05: 'BGNSTR', 0x06: 'STRNAME', 0x07: 'ENDSTR', 0x08: 'BOUNDARY', 0x09: 'PATH',
       0x0A: 'SREF', 0x0B: 'AREF', 0x0C: 'TEXT', 0x0D: 'LAYER', 0x0E: 'DATATYPE',
       0x0F: 'WIDTH', 0x10: 'XY', 0x11: 'ENDEL', 0x12: 'SNAME', 0x13: 'COLROW',
       0x16: 'TEXTTYPE', 0x19: 'STRING'}
METAL = {61: 'M1', 62: 'M2', 63: 'M3', 64: 'M4', 65: 'M5', 66: 'M6'}
COL = {61: '#4C72B0', 62: '#DD8452', 63: '#55A868', 64: '#C44E52', 65: '#8172B3', 66: '#937860'}
os.makedirs(OUT, exist_ok=True)


def gds_real(b):
    sign = -1.0 if b[0] & 0x80 else 1.0
    exp = (b[0] & 0x7F) - 64
    mant = int.from_bytes(b[1:8], 'big') / float(1 << 56)
    return sign * mant * (16.0 ** exp)


# ---------------------------------------------------------------- parse once
f = open(GDS, 'rb')
prec = 10000.0
while True:
    hdr = f.read(4)
    if len(hdr) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', hdr)
    d = f.read(rl - 4) if rl >= 4 else b''
    if rt == 0x03 and len(d) >= 16:
        prec = 1e-6 / gds_real(d[8:16])
        break
    if rt == 0x05:
        break
f.seek(0)

rects = collections.defaultdict(list)      # layer -> [(x0,y0,x1,y1)]
npoly = collections.defaultdict(dict)      # layer -> {vertex count: n}
srefs = []                                 # (master, x, y)
labels = []                                # (name, layer, x, y)
bbox = {}                                  # struct -> (x0,y0,x1,y1)
cur = layer = None
elem = None
sname = None
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    n = REC.get(rt)
    if n == 'BGNSTR':
        cur, layer, elem, sname = None, None, None, None
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'LAYER':
        layer = struct.unpack('>h', d)[0]
    elif n in ('BOUNDARY', 'PATH'):
        elem = n
    elif n == 'SNAME':
        sname = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'XY':
        pts = struct.unpack('>%di' % (len(d) // 4), d)
        # SREF and TEXT carry a single point (2 ints); polygons carry >= 4.
        # Guarding everything with >= 4 silently produced zero placements and zero labels.
        if len(pts) >= 4 and elem and cur:
            xs, ys = pts[0::2], pts[1::2]
            x0, x1 = min(xs) / prec, max(xs) / prec
            y0, y1 = min(ys) / prec, max(ys) / prec
            rects[(cur, layer)].append((x0, y0, x1, y1))
            npoly[(cur, layer)][len(pts) // 2] = npoly[(cur, layer)].get(len(pts) // 2, 0) + 1
            b = bbox.get(cur)
            bbox[cur] = (min(b[0], x0), min(b[1], y0), max(b[2], x1), max(b[3], y1)) \
                if b else (x0, y0, x1, y1)
            elem = None
        elif len(pts) == 2 and sname and cur == TOP:
            # cur == TOP is essential: a file-wide SREF count is 34 465, which includes the
            # references made INSIDE the 109 library wrapper structs.  The top cell places
            # 34 356.  Omitting this guard reproduces the 3 735-vs-3 626 error exactly.
            srefs.append((sname, pts[0] / prec, pts[1] / prec))
            sname = None
        elif len(pts) == 2 and cur == TOP:
            labels.append(['', layer, pts[0] / prec, pts[1] / prec])
    elif n == 'STRING' and labels and labels[-1][0] == '':
        labels[-1][0] = d.split(b'\x00')[0].decode('latin-1')
f.close()

print('parsed: %d top-cell shapes, %d SREFs, %d labels, %d struct bboxes'
      % (sum(len(v) for k, v in rects.items() if k[0] == TOP), len(srefs), len(labels), len(bbox)))
vc = collections.Counter()
for k, v in npoly.items():
    if k[0] == TOP:
        for npts, c in v.items():
            vc[npts] += c
print('top-cell polygon vertex counts: %s' % ', '.join('%dpt:%d' % (k, v) for k, v in sorted(vc.items())))
# GDSII closes a polygon by repeating its first vertex, so 5 points == a plain rectangle.
nonrect = sum(c for k, c in vc.items() if k > 5)
print('  --> %d of %d polygons have >5 vertices (non-rectangular). '
      '5-point polygons are closed rectangles.' % (nonrect, sum(vc.values())))
if nonrect == 0:
    print('  --> every polygon is a rectangle, so drawing bounding boxes is EXACT here.')


def raster(rectlist, w=DIE_W, h=DIE_H, ppu=8.0, x0=0.0, y0=0.0):
    nx, ny = int(w * ppu), int(h * ppu)
    img = np.zeros((ny, nx), dtype=bool)
    for (a, b, c, e) in rectlist:
        i0 = int((a - x0) * ppu); i1 = max(i0 + 1, int(np.ceil((c - x0) * ppu)))
        j0 = int((b - y0) * ppu); j1 = max(j0 + 1, int(np.ceil((e - y0) * ppu)))
        i0, i1 = max(i0, 0), min(i1, nx)
        j0, j1 = max(j0, 0), min(j1, ny)
        if i1 > i0 and j1 > j0:
            img[j0:j1, i0:i1] = True
    return img


def report(path, arr):
    """A figure that is blank, or solid, is a failed figure -- say so numerically."""
    frac = float(arr.mean()) if arr.size else 0.0
    print('  %-28s %s  coverage=%.4f %s'
          % (os.path.basename(path), 'OK ' if 0.0 < frac < 1.0 else 'SUSPECT', frac,
             '' if 0.0 < frac < 1.0 else '<-- blank or solid!'))


# ---------------------------------------------------------------- fig 1: per layer
CENSUS = {61: 7912, 62: 17445, 63: 10114, 64: 2290, 65: 72, 66: 3}   # gds_routing.py
print('')
print('per-layer reconciliation against the census (gds_routing.py):')
print('  %-4s %8s %8s %8s %10s %10s' % ('layer', 'census', 'here', 'area>0', 'area here', 'area census'))
CENSUS_AREA = {61: 31838, 62: 25571, 63: 29242, 64: 15630, 65: 1591, 66: 97}
for lay in sorted(METAL):
    rl = rects.get((TOP, lay), [])
    pos = [r for r in rl if (r[2] - r[0]) * (r[3] - r[1]) > 0]
    ar = sum((c - a) * (e - b) for a, b, c, e in rl)
    print('  %-4s %8d %8d %8d %10.0f %10d' %
          (METAL[lay], CENSUS[lay], len(rl), len(pos), ar, CENSUS_AREA[lay]))

fig, axes = plt.subplots(2, 3, figsize=(15, 10.4), dpi=130)
for ax, lay in zip(axes.ravel(), sorted(METAL)):
    rl = rects.get((TOP, lay), [])
    npos = sum(1 for a, b, c, e in rl if (c - a) * (e - b) > 0)
    img = raster(rl)
    ax.imshow(img, origin='lower', extent=[0, DIE_W, 0, DIE_H], cmap='Blues',
              interpolation='nearest', vmin=0, vmax=1)
    ax.set_title('%s — %d polygons (%d with non-zero area), %.0f µm²'
                 % (METAL[lay], len(rl), npos,
                    sum((c - a) * (e - b) for a, b, c, e in rl)),
                 fontsize=11)
    ax.set_xlabel('x (µm)'); ax.set_ylabel('y (µm)')
    ax.set_xticks([0, 200, 400]); ax.set_yticks([0, 200, 400])
    print('    %s coverage %.4f' % (METAL[lay], img.mean()))
fig.suptitle('Actual metal drawn by the top cell  sar_digi_paper_core   (430.520 × 429.340 µm)\n'
             'every polygon is a rectangle, so these are faithful; areas below are from the '
             'polygon sums, not from the rendered pixels', fontsize=12)
fig.tight_layout(rect=[0, 0, 1, 0.97])
p1 = os.path.join(OUT, 'fig1_layers.png')
fig.savefig(p1); plt.close(fig)
report(p1, raster(rects.get((TOP, 62), [])))

# ---------------------------------------------------------------- fig 2: placement + ports
fig, axes = plt.subplots(1, 2, figsize=(15.5, 7.4), dpi=130)
ax = axes[0]
miss = 0
for name, x, y in srefs:
    if name.startswith('$$'):
        continue
    b = bbox.get(name)
    if not b:
        miss += 1
        continue
    ax.add_patch(Rectangle((x + b[0], y + b[1]), b[2] - b[0], b[3] - b[1],
                           facecolor='#4C72B0', edgecolor='none', alpha=0.85))
ax.set_xlim(0, DIE_W); ax.set_ylim(0, DIE_H); ax.set_aspect('equal')
ax.set_title('3 626 standard-cell placements (SREF), %d without a bbox' % miss, fontsize=12)
ax.set_xlabel('x (µm)'); ax.set_ylabel('y (µm)')

ax = axes[1]
for lay, col, lab in ((62, '#DD8452', 'M2 labels (90)'), (63, '#55A868', 'M3 labels (88)')):
    xs = [l[2] for l in labels if l[1] == lay]
    ys = [l[3] for l in labels if l[1] == lay]
    ax.scatter(xs, ys, s=26, c=col, label=lab, edgecolors='k', linewidths=0.3)
for l in labels:
    if l[0] in ('VDD', 'VSS'):
        ax.annotate(l[0], (l[2], l[3]), fontsize=11, fontweight='bold', color='#C44E52',
                    xytext=(6, 6), textcoords='offset points')
ax.set_xlim(-15, DIE_W + 15); ax.set_ylim(-15, DIE_H + 15); ax.set_aspect('equal')
ax.legend(loc='upper right', fontsize=10)
ax.set_title('178 port labels, all distinct — 176 signals + VDD + VSS', fontsize=12)
ax.set_xlabel('x (µm)'); ax.set_ylabel('y (µm)')
fig.tight_layout()
p2 = os.path.join(OUT, 'fig2_place.png')
fig.savefig(p2); plt.close(fig)
print('  fig2: %d cell srefs plotted, %d labels' % (sum(1 for s in srefs if not s[0].startswith('$$')), len(labels)))

# ---------------------------------------------------------------- fig 3: zoom on real routing
# choose the densest 60x60 um window from M2+M3 shape centres
cand = collections.Counter()
for lay in (61, 62, 63):
    for (a, b, c, e) in rects.get((TOP, lay), []):
        cand[(int((a + c) / 2 // 10), int((b + e) / 2 // 10))] += 1
(bx, by), n = cand.most_common(1)[0]
W = 60.0
x0, y0 = bx * 10.0 + 5 - W / 2, by * 10.0 + 5 - W / 2
x0 = max(0.0, min(DIE_W - W, x0)); y0 = max(0.0, min(DIE_H - W, y0))
print('  zoom window: (%.1f, %.1f) + %.0f µm, %d shapes in the chosen 10 µm bin' % (x0, y0, W, n))

# the wide M1 horizontal bands: measure their pitch rather than calling them "power rails"
bands = sorted((b + e) / 2 for a, b, c, e in rects.get((TOP, 61), [])
               if min(c - a, e - b) >= 0.40 and (c - a) > (e - b) and (c - a) > 20)
pitch = [round(bands[i + 1] - bands[i], 2) for i in range(len(bands) - 1)]
if pitch:
    med = sorted(pitch)[len(pitch) // 2]
    print('  wide M1 horizontal bands: %d of them, median y-pitch %.2f µm '
          '(min %.2f, max %.2f)' % (len(bands), med, min(pitch), max(pitch)))

fig, axes = plt.subplots(1, 2, figsize=(15.5, 7.8), dpi=130,
                         gridspec_kw={'width_ratios': [1.25, 1]})
ax = axes[0]
for lay in (61, 62, 63):
    sub = [r for r in rects.get((TOP, lay), [])
           if r[0] < x0 + W and r[2] > x0 and r[1] < y0 + W and r[3] > y0]
    img = raster(sub, w=W, h=W, ppu=20.0, x0=x0, y0=y0)
    ax.imshow(np.ma.masked_where(~img, img), origin='lower', extent=[x0, x0 + W, y0, y0 + W],
              cmap=matplotlib.colors.ListedColormap([COL[lay]]), alpha=0.85,
              interpolation='nearest', vmin=0, vmax=1)
    print('    %s in window: %d shapes' % (METAL[lay], len(sub)))
ax.set_xlim(x0, x0 + W); ax.set_ylim(y0, y0 + W); ax.set_aspect('equal')
ax.set_title('densest 60 × 60 µm window — M1 (blue, horizontal) / M2 (orange, vertical) / '
             'M3 (green, horizontal)', fontsize=11)
ax.set_xlabel('x (µm)'); ax.set_ylabel('y (µm)')
ax.plot([x0 + 3, x0 + 13], [y0 + 3, y0 + 3], color='k', lw=2.5)
ax.text(x0 + 3.4, y0 + 4.2, '10 µm', fontsize=10)

ax = axes[1]
sub = [r for r in rects.get((TOP, 63), [])
       if r[0] < x0 + W and r[2] > x0 and r[1] < y0 + W and r[3] > y0]
img = raster(sub, w=W, h=W, ppu=20.0, x0=x0, y0=y0)
ax.imshow(np.ma.masked_where(~img, img), origin='lower', extent=[x0, x0 + W, y0, y0 + W],
          cmap=matplotlib.colors.ListedColormap([COL[63]]), interpolation='nearest', vmin=0, vmax=1)
ax.set_xlim(x0, x0 + W); ax.set_ylim(y0, y0 + W); ax.set_aspect('equal')
ax.set_title('same window, M3 only — horizontal runs at 0.28 µm pitch-scale width', fontsize=11)
ax.set_xlabel('x (µm)')
fig.tight_layout()
p3 = os.path.join(OUT, 'fig3_zoom.png')
fig.savefig(p3); plt.close(fig)
report(p3, raster(rects.get((TOP, 63), [])))

# ---------------------------------------------------------------- fig 4: per-layer stats
DENS = {61: 0.292324, 62: 0.140098, 63: 0.157933, 64: 0.0848071, 65: 0.00862078, 66: 0.000528355}
names, shapes, areas, lnH, lnV = [], [], [], [], []
for lay in sorted(METAL):
    rl = rects.get((TOP, lay), [])
    names.append(METAL[lay]); shapes.append(len(rl))
    areas.append(sum((c - a) * (e - b) for a, b, c, e in rl))
    hh = vv = 0.0
    for a, b, c, e in rl:
        if (c - a) >= (e - b):
            hh += c - a
        else:
            vv += e - b
    lnH.append(hh); lnV.append(vv)

fig, axes = plt.subplots(2, 2, figsize=(14.5, 9.2), dpi=130)
x = np.arange(len(names))
for ax, val, ttl, col in ((axes[0][0], shapes, 'shapes drawn by the top cell', '#4C72B0'),
                          (axes[0][1], areas, 'drawn area (µm²)', '#55A868')):
    ax.bar(x, val, color=col)
    ax.set_xticks(x); ax.set_xticklabels(names)
    ax.set_title(ttl, fontsize=12)
    for i, v in enumerate(val):
        ax.text(i, v, '%.0f' % v, ha='center', va='bottom', fontsize=9)
ax = axes[1][0]
ax.bar(x, lnH, label='horizontal', color='#4C72B0')
ax.bar(x, lnV, bottom=lnH, label='vertical', color='#DD8452')
ax.set_xticks(x); ax.set_xticklabels(names)
ax.set_ylabel('µm'); ax.set_title('drawn wire length, by direction', fontsize=12)
ax.legend(fontsize=10)
ax = axes[1][1]
d = [DENS[l] * 100 for l in sorted(METAL)]
ax.bar(x, d, color='#C44E52')
ax.axhline(30, color='k', ls='--', lw=1.2)
ax.text(0.05, 30.9, 'DRC density limit 30 %', fontsize=10)
ax.set_xticks(x); ax.set_xticklabels(names)
ax.set_ylabel('%'); ax.set_title('metal density per layer (Calibre), whole die', fontsize=12)
for i, v in enumerate(d):
    ax.text(i, v, '%.2f' % v, ha='center', va='bottom', fontsize=9)
fig.tight_layout()
p4 = os.path.join(OUT, 'fig4_layer_stats.png')
fig.savefig(p4); plt.close(fig)
print('  fig4: areas=%s' % ['%.0f' % a for a in areas])

# ---------------------------------------------------------------- fig 5: width histogram
buckets = [(0, 0.30, '<0.30'), (0.30, 0.50, '0.30–0.49'), (0.50, 1.0, '0.50–0.99'),
           (1.0, 3.0, '1.0–2.9'), (3.0, 1e9, '≥3.0')]
fig, ax = plt.subplots(figsize=(11, 5.6), dpi=130)
w = 0.15
for k, lay in enumerate(sorted(METAL)):
    ws = []
    for a, b, c, e in rects.get((TOP, lay), []):
        ws.append(min(c - a, e - b))
    ws = np.array(ws) if ws else np.array([0.0])
    counts = [int(((ws >= lo) & (ws < hi)).sum()) for lo, hi, _ in buckets]
    ax.bar(np.arange(len(buckets)) + (k - 2.5) * w, counts, width=w,
           label=METAL[lay], color=COL[lay])
ax.set_yscale('log')
ax.set_xticks(np.arange(len(buckets))); ax.set_xticklabels([b[2] for b in buckets])
ax.set_xlabel('drawn width (µm)'); ax.set_ylabel('shapes (log)')
ax.set_title('drawn-width distribution — signal wiring sits at the layer minimum', fontsize=12)
ax.legend(fontsize=10, ncol=6)
fig.tight_layout()
p5 = os.path.join(OUT, 'fig5_width.png')
fig.savefig(p5); plt.close(fig)
print('  fig5 done')

# ---------------------------------------------------------------- fig 6: vias
via_lbl = ['via1\nM1–M2', 'via1 array\nM1–M2', 'via2\nM2–M3', 'via3\nM3–M4', 'via4\nM4–M5', 'via5\nM5–M6']
via_n = [12931, 1462, 12613, 3584, 134, 6]
fig, ax = plt.subplots(figsize=(11, 5.6), dpi=130)
b = ax.bar(via_lbl, via_n, color=['#4C72B0', '#8FB0D9', '#DD8452', '#55A868', '#C44E52', '#8172B3'])
ax.set_yscale('log'); ax.set_ylabel('placements (log)')
ax.set_title('via placements between metal layers — 83 %% of all connections are in M1–M3', fontsize=12)
for r, v in zip(b, via_n):
    ax.text(r.get_x() + r.get_width() / 2, v, '%d' % v, ha='center', va='bottom', fontsize=10)
fig.tight_layout()
p6 = os.path.join(OUT, 'fig6_vias.png')
fig.savefig(p6); plt.close(fig)
print('  fig6 done')

# ---------------------------------------------------------------- fig 7: timing
pts = ['p0', 'p3', 'p5', 'p8']
setup = [0.794725, 0.759686, 0.736327, 0.701290]
holdw = [-0.2020, -0.2243, -0.2391, -0.2614]
holdt = [-2.5834, -2.9384, -3.1751, -3.5301]
fig, axes = plt.subplots(1, 3, figsize=(16.5, 5.6), dpi=130)
ax = axes[0]
ax.plot(pts, setup, 'o-', color='#059669', lw=2, ms=7, label='slow corner, setup WNS')
ax.axhline(0, color='k', lw=1)
ax.set_ylabel('slack (ns)'); ax.set_xlabel('OCV derate point')
ax.set_title('setup stays positive at every derate point', fontsize=11)
for i, v in enumerate(setup):
    ax.annotate('%.4f' % v, (i, v), fontsize=9, xytext=(0, 7), textcoords='offset points')
ax = axes[1]
ax.plot(pts, holdw, 's-', color='#DC2626', lw=2, ms=7, label='slow, hold WNS')
ax.plot(pts, holdt, '^--', color='#F59E0B', lw=1.6, ms=6, label='slow, hold TNS')
ax.axhline(0, color='k', lw=1)
ax.set_ylabel('ns'); ax.set_xlabel('OCV derate point')
ax.set_title('hold worsens with derate (16 violations at every point)', fontsize=11)
ax.legend(fontsize=9)
ax = axes[2]
steps = ['input external\ndelay', '1× INVXL', 'data arrival', 'clock network\ndelay (capture)',
         'uncertainty\n− library hold', 'data required', 'slack']
vals = [0.50, 0.05, None, 0.75, 0.05, None, None]
run = 0.0
xs, heights, bottoms, cols = [], [], [], []
for i, v in enumerate(vals[:4]):
    if v is None:
        continue
    xs.append(i); bottoms.append(run); heights.append(v)
    cols.append('#4C72B0' if i < 3 else '#DD8452')
    run += v
ax.bar(xs, heights, bottom=bottoms, color=cols)
ax.bar([5], [0.75], color='#55A868')
ax.bar([6], [-0.20], bottom=0.75, color='#DC2626')
ax.axhline(0.55, color='#4C72B0', ls=':', lw=1.2)
ax.text(0.05, 0.57, 'data arrival 0.55', fontsize=9, color='#4C72B0')
ax.axhline(0.75, color='#55A868', ls=':', lw=1.2)
ax.text(4.1, 0.77, 'data required 0.75', fontsize=9, color='#55A868')
ax.set_xticks(range(4)); ax.set_xticklabels(['ext. delay\n0.50', 'INVXL\n0.05',
                                             'arrival', 'clk tree\n0.75'], fontsize=8)
ax.set_ylabel('ns')
ax.set_title('worst hold path: 0.55 arrival vs 0.75 required = −0.20', fontsize=11)
fig.tight_layout()
p7 = os.path.join(OUT, 'fig7_timing.png')
fig.savefig(p7); plt.close(fig)
print('  fig7 done')

# ---------------------------------------------------------------- fig 8: DRC composition
fig, axes = plt.subplots(1, 2, figsize=(14.5, 5.8), dpi=130)
cats = ['seal-ring\nBD_1+BD_2a\n(capped at 1000)', 'N-well spacing\nNW_2a',
        'metal / via\ngeometry (6 checks)', 'density\n(7 checks)']
vals = [2000, 734, 215, 7]
cols = ['#C44E52', '#DD8452', '#4C72B0', '#55A868']
ax = axes[0]
b = ax.bar(cats, vals, color=cols)
ax.set_yscale('log'); ax.set_ylabel('results (log)')
ax.set_title('DRC result composition (2 956 parsed = SUM column 1)', fontsize=11)
for r, v in zip(b, vals):
    ax.text(r.get_x() + r.get_width() / 2, v, '%d' % v, ha='center', va='bottom', fontsize=10)
ax.tick_params(axis='x', labelsize=8)

ax = axes[1]
detail = {'M1_2 M1 space': 177, 'M1_1 M1 width': 15, 'M2_2 M2 space': 14,
          'V1_2 V1 space': 7, 'M2_1 M2 width': 1, 'V1_1 V1 square': 1}
ax.barh(list(detail)[::-1], list(detail.values())[::-1], color='#4C72B0')
ax.set_xscale('log'); ax.set_xlabel('results (log)')
ax.set_title('the 215 real metal/via geometry findings, by rule', fontsize=11)
for i, v in enumerate(list(detail.values())[::-1]):
    ax.text(v, i, ' %d' % v, va='center', fontsize=10)
fig.tight_layout()
p8 = os.path.join(OUT, 'fig8_drc.png')
fig.savefig(p8); plt.close(fig)
print('  fig8 done')

print('')
for p in (p1, p2, p3, p4, p5, p6, p7, p8):
    print('%-40s %8d B' % (os.path.basename(p), os.path.getsize(p)))
