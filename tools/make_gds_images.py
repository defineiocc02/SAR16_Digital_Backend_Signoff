"""Render the delivered GDS as actual LAYOUT PICTURES (flattened, layout-viewer style).

Unlike the earlier per-layer analysis (which deliberately showed only what the TOP cell
draws), this flattens the hierarchy: every SREF instance is expanded with its mirror /
rotation and its cell geometry is drawn, which is what the file actually looks like in a
layout viewer.

Outputs (dark background, one colour per layer, lower layers painted first):
  gds_full.png        the whole die, flattened, with a legend
  gds_layers_flat.png M1..M6 flattened, one panel per layer
  gds_zoom3.png       three magnifications of the same area: 80 / 20 / 5 um
  gds_split.png       cell interiors vs top-level routing, same window

Layer 127 is a per-cell OUTLINE (109 shapes, one per master).  Filling it would turn every
standard cell into a solid block, so it is drawn as an outline only -- at 1 px it would be
invisible anyway, hence it is omitted and named in the legend instead.
"""
import collections
import io
import os
import struct
import sys
import math

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Patch
import numpy as np

sys.stdout.reconfigure(encoding='utf-8')

GDS = '../evidence/rpt_v51/sar_digi_paper_core_merged.gds'
OUT = '../evidence/figures'
TOP = 'sar_digi_paper_core'
DIE_W, DIE_H = 430.520, 429.340
os.makedirs(OUT, exist_ok=True)

REC = {0x05: 'BGNSTR', 0x06: 'STRNAME', 0x07: 'ENDSTR', 0x08: 'BOUNDARY', 0x09: 'PATH',
       0x0A: 'SREF', 0x0B: 'AREF', 0x0C: 'TEXT', 0x0D: 'LAYER', 0x0E: 'DATATYPE',
       0x10: 'XY', 0x11: 'ENDEL', 0x12: 'SNAME', 0x1A: 'STRANS', 0x1C: 'ANGLE'}

# paint order (bottom first) and colours, layout-viewer style
STYLE = [
    (10, 'AA active',    '#2F6B3A'),
    (14, 'NW well',      '#4A4A4A'),
    (30, 'GT poly',      '#B4472A'),
    (40, 'SN',           '#2C4E76'),
    (43, 'SP',           '#5B3A78'),
    (50, 'CT contact',   '#8A8A8A'),
    (61, 'M1',           '#3E7FD1'),
    (62, 'M2',           '#D98A2B'),
    (63, 'M3',           '#43B36B'),
    (64, 'M4',           '#C85A5A'),
    (65, 'M5',           '#9B7BD4'),
    (66, 'M6',           '#C9A227'),
    (70, 'V1 cut',       '#EDEDED'),
    (71, 'V2 cut',       '#EDEDED'),
    (72, 'V3 cut',       '#EDEDED'),
    (73, 'V4 cut',       '#EDEDED'),
    (74, 'V5 cut',       '#EDEDED'),
]
COLOR = {l: c for l, _, c in STYLE}
LABEL = {l: n for l, n, _ in STYLE}


def gds_real(b):
    sign = -1.0 if b[0] & 0x80 else 1.0
    return sign * (int.from_bytes(b[1:8], 'big') / float(1 << 56)) * (16.0 ** ((b[0] & 0x7F) - 64))


# ------------------------------------------------------------------ parse the hierarchy
f = open(GDS, 'rb')
prec = 10000.0
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    if rt == 0x03 and len(d) >= 16:
        prec = 1e-6 / gds_real(d[8:16]); break
    if rt == 0x05:
        break
f.seek(0)

cell = collections.defaultdict(lambda: collections.defaultdict(list))   # struct -> layer -> rects
inst = collections.defaultdict(list)      # struct -> [(master, x, y, mirror, angle)]
cur = layer = elem = sname = None
strans = 0
angle = 0.0
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    n = REC.get(rt)
    if n == 'BGNSTR':
        cur = layer = elem = sname = None
        strans = 0
        angle = 0.0
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'LAYER':
        layer = struct.unpack('>h', d)[0]
    elif n in ('BOUNDARY', 'PATH'):
        elem = n
    elif n == 'SNAME':
        sname = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'STRANS':
        strans = struct.unpack('>H', d)[0]
    elif n == 'ANGLE':
        angle = float(gds_real(d)) if len(d) == 8 else float(struct.unpack('>h', d)[0])
    elif n == 'ENDEL':
        # 0x11 ENDEL.  Spelling this 'ENDELEM' (or omitting 0x11 from REC) means the
        # STRANS/ANGLE state is never cleared, and one stale "ANGLE 90" then leaks onto
        # nearly every instance -- the placements look plausible but are all wrong.
        strans = 0
        angle = 0.0
    elif n == 'XY':
        pts = struct.unpack('>%di' % (len(d) // 4), d)
        if len(pts) >= 4 and elem and cur:
            xs, ys = pts[0::2], pts[1::2]
            cell[cur][layer].append((min(xs) / prec, min(ys) / prec,
                                     max(xs) / prec, max(ys) / prec))
            elem = None
        elif len(pts) == 2 and sname and cur:
            inst[cur].append((sname, pts[0] / prec, pts[1] / prec,
                              bool(strans & 0x8000), angle))
            sname = None
f.close()

print('structs with geometry : %d' % len(cell))
print('top-cell instances    : %d' % len(inst[TOP]))


def matmul(A, B):
    """3x3 matrix product.  The first version of this unpacked the third row into a scalar
    and crashed on the first instance."""
    return tuple(tuple(sum(A[i][k] * B[k][j] for k in range(3)) for j in range(3))
                 for i in range(3))


def inst_matrix(ix, iy, mirror, ang):
    """GDSII order: mirror about the x axis, then rotate, then translate."""
    a = math.radians(ang % 360.0)
    ca, sa = round(math.cos(a)), round(math.sin(a))
    R = ((ca, -sa, 0.0), (sa, ca, 0.0), (0.0, 0.0, 1.0))
    S = ((1.0, 0.0, 0.0), (0.0, -1.0 if mirror else 1.0, 0.0), (0.0, 0.0, 1.0))
    T = ((1.0, 0.0, ix), (0.0, 1.0, iy), (0.0, 0.0, 1.0))
    return matmul(T, matmul(R, S))


def apply_m(M, b):
    x0, y0, x1, y1 = b
    xs, ys = [], []
    for (x, y) in ((x0, y0), (x0, y1), (x1, y0), (x1, y1)):
        xs.append(M[0][0] * x + M[0][1] * y + M[0][2])
        ys.append(M[1][0] * x + M[1][1] * y + M[1][2])
    return (min(xs), min(ys), max(xs), max(ys))


CUTS = {70, 71, 72, 73, 74}
flat = collections.defaultdict(list)          # layer -> rects (whole design)
cellonly = collections.defaultdict(list)      # layer -> rects from cell masters only


def expand(name, M, depth=0):
    """Recursive flatten.  The delivered file is TWO levels deep: the top cell references
    wrappers such as AND2XL that draw only the layer-127 outline and reference the real cell
    (and2_lxawwqwwwwwcuo55yy), which is where AA / GT / SN / SP / NW / M1 live.  Expanding a
    single level therefore skipped every standard cell entirely -- the first version of this
    script did exactly that and produced layout pictures with no transistors in them."""
    for lay, rs in cell.get(name, {}).items():
        if lay == 127:
            continue
        t = [apply_m(M, b) for b in rs]
        flat[lay].extend(t)
        if depth > 0:
            cellonly[lay].extend(t)
    for (m, ix, iy, mir, ang) in inst.get(name, []):
        expand(m, matmul(M, inst_matrix(ix, iy, mir, ang)), depth + 1)


expand(TOP, ((1.0, 0.0, 0.0), (0.0, 1.0, 0.0), (0.0, 0.0, 1.0)))
print('NOTE: via masters are expanded too, so the metal counts below include the via pads.')

tot = sum(len(v) for v in flat.values())
print('flattened rects       : %d   (layers: %s)' % (tot, ', '.join(str(l) for l in sorted(flat))))
for lay in sorted(flat):
    print('   %-4s %-12s %8d rects' % (lay, LABEL.get(lay, '?'), len(flat[lay])))

oob = sum(1 for rs in flat.values() for (a, b, c, e) in rs
          if a < -1 or b < -1 or c > DIE_W + 1 or e > DIE_H + 1)
print('rects outside the die : %d  (0 expected; >0 means a transform is wrong)' % oob)
print('rects from cell masters: %d' % sum(len(v) for v in cellonly.values()))


def paint(layers, w, h, ppu, x0, y0, rects_by_layer, order=None):
    nx, ny = int(round(w * ppu)), int(round(h * ppu))
    img = np.zeros((ny, nx, 3), dtype=np.float32)
    for lay in (order or [l for l, _, _ in STYLE]):
        rs = rects_by_layer.get(lay)
        if not rs:
            continue
        rgb = np.array(matplotlib.colors.to_rgb(COLOR.get(lay, '#888888')), dtype=np.float32)
        m = np.zeros((ny, nx), dtype=bool)
        for (a, b, c, e) in rs:
            if c < x0 or a > x0 + w or e < y0 or b > y0 + h:
                continue
            i0, i1 = int((a - x0) * ppu), max(int((a - x0) * ppu) + 1, int(np.ceil((c - x0) * ppu)))
            j0, j1 = int((b - y0) * ppu), max(int((b - y0) * ppu) + 1, int(np.ceil((e - y0) * ppu)))
            i0, i1 = max(i0, 0), min(i1, nx)
            j0, j1 = max(j0, 0), min(j1, ny)
            if i1 > i0 and j1 > j0:
                m[j0:j1, i0:i1] = True
        img[m] = rgb
    return img


def coverage(layers, rects_by_layer):
    return sum(len(rects_by_layer.get(l, [])) for l in layers)


# ------------------------------------------------------------------ 1: whole die
print('\nrendering gds_full ...')
img = paint(None, DIE_W, DIE_H, 7.0, 0, 0, flat)
fig, axes = plt.subplots(1, 2, figsize=(17, 8.8), dpi=130,
                         gridspec_kw={'width_ratios': [1, 0.30]})
axes[0].imshow(img, origin='lower', extent=[0, DIE_W, 0, DIE_H], interpolation='nearest')
axes[0].set_title('delivered GDS, flattened -sar_digi_paper_core  430.520 x 429.340 umm', fontsize=12)
axes[0].set_xlabel('x (umm)'); axes[0].set_ylabel('y (umm)')
axes[0].set_facecolor('#111111')
axes[1].axis('off')
handles = [Patch(facecolor=COLOR[l], label='%s  (%s)' % (n, l)) for l, n, _ in STYLE
           if flat.get(l)]
handles.append(Patch(facecolor='none', edgecolor='#888888',
                     label='layer 127 = per-cell outline (not filled)'))
axes[1].legend(handles=handles, loc='upper left', fontsize=9.5, frameon=False, ncol=1)
axes[1].set_title('layers present in the file', fontsize=11)
fig.tight_layout()
p = os.path.join(OUT, 'gds_full.png')
fig.savefig(p); plt.close(fig)
print('  %s  %d B   pixels non-black %.3f' % (p, os.path.getsize(p),
                                               float((img.sum(axis=2) > 0).mean())))

# ------------------------------------------------------------------ 2: per layer, flattened
print('rendering gds_layers_flat ...')
show = [61, 62, 63, 64, 65, 66]
fig, axes = plt.subplots(2, 3, figsize=(16, 10.6), dpi=130)
for ax, lay in zip(axes.ravel(), show):
    im = paint([lay], DIE_W, DIE_H, 6.0, 0, 0, flat, order=[lay])
    ax.imshow(im, origin='lower', extent=[0, DIE_W, 0, DIE_H], interpolation='nearest')
    ax.set_facecolor('#111111')
    ax.set_title('%s -%d rectangles flattened' % (LABEL[lay], len(flat.get(lay, []))), fontsize=12)
    ax.set_xticks([0, 200, 400]); ax.set_yticks([0, 200, 400])
fig.suptitle('per-layer flattened views (cell interiors included) -'
             'note how little M5/M6 carries', fontsize=13)
fig.tight_layout(rect=[0, 0, 1, 0.96])
p2 = os.path.join(OUT, 'gds_layers_flat.png')
fig.savefig(p2); plt.close(fig)
print('  %s  %d B' % (p2, os.path.getsize(p2)))

# ------------------------------------------------------------------ 3: zoom levels
# densest window, computed on the flattened metal
cand = collections.Counter()
for lay in (61, 62, 63):
    for (a, b, c, e) in flat.get(lay, []):
        cand[(int((a + c) / 2 // 10), int((b + e) / 2 // 10))] += 1
(bx, by), n = cand.most_common(1)[0]
cx, cy = bx * 10.0 + 5, by * 10.0 + 5
print('rendering gds_zoom3 around (%.0f, %.0f), densest 10 umm bin has %d flattened shapes'
      % (cx, cy, n))
fig, axes = plt.subplots(1, 3, figsize=(17, 6.2), dpi=130)
for ax, W, ppu in zip(axes, (80.0, 20.0, 5.0), (7.0, 22.0, 80.0)):
    x0 = min(max(cx - W / 2, 0.0), DIE_W - W)
    y0 = min(max(cy - W / 2, 0.0), DIE_H - W)
    im = paint(None, W, W, ppu, x0, y0, flat)
    ax.imshow(im, origin='lower', extent=[x0, x0 + W, y0, y0 + W], interpolation='nearest')
    ax.set_facecolor('#111111')
    ax.set_title('%g x %g umm' % (W, W), fontsize=12)
    ax.set_xlabel('x (umm)')
    ax.plot([x0 + 0.05 * W, x0 + 0.05 * W + min(W / 4, 10)], [y0 + 0.05 * W] * 2, color='w', lw=2)
axes[0].set_ylabel('y (umm)')
fig.suptitle('same area at three magnifications -routing on top of standard-cell rows '
             '(M1 blue / M2 orange / M3 green / poly red / AA dark green)', fontsize=12)
fig.tight_layout(rect=[0, 0, 1, 0.94])
p3 = os.path.join(OUT, 'gds_zoom3.png')
fig.savefig(p3); plt.close(fig)
print('  %s  %d B' % (p3, os.path.getsize(p3)))

# ------------------------------------------------------------------ 4: what the layout is made of
W = 30.0
x0 = min(max(cx - W / 2, 0.0), DIE_W - W)
y0 = min(max(cy - W / 2, 0.0), DIE_H - W)
DEVICE = [10, 14, 30, 40, 43, 50]          # AA / NW / GT / SN / SP / CT
# For the device panel the paint order matters: SN/SP/NW are large implant regions and GT
# and AA are the fine structures inside them, so paint the implants FIRST and the gate /
# active layers last, otherwise the panel is a flat field of implant colour.
DEVICE_ORDER = [43, 40, 14, 10, 50, 30]
print('rendering gds_split (device layers -> cell interiors -> complete) ...')
fig, axes = plt.subplots(1, 3, figsize=(17.5, 6.4), dpi=130)
panels = [
    (DEVICE_ORDER, '(1) device layers only\nAA (dark green) / NW / GT poly (red) / SN / SP / CT'),
    ([l for l, _, _ in STYLE if l not in DEVICE and not l in CUTS] + sorted(CUTS),
     '(2) + cell metal and via cuts\n(everything the cell masters draw)'),
    (None, '(3) complete layout\n(cells + place & route)'),
]
for ax, (order, ttl) in zip(axes, panels):
    im = paint(order if order else None, W, W, 20.0, x0, y0,
               cellonly if order and 66 not in order else flat,
               order=order) if order else paint(None, W, W, 20.0, x0, y0, flat)
    ax.imshow(im, origin='lower', extent=[x0, x0 + W, y0, y0 + W], interpolation='nearest')
    ax.set_facecolor('#111111')
    ax.set_title(ttl, fontsize=10.5)
    ax.set_xlabel('x (umm)')
axes[0].set_ylabel('y (umm)')
fig.suptitle('%g x %g umm window at (%.0f, %.0f) -the same area, showing layer by layer what '
             'the file is made of' % (W, W, x0, y0), fontsize=12)
fig.tight_layout(rect=[0, 0, 1, 0.93])
p4 = os.path.join(OUT, 'gds_split.png')
fig.savefig(p4); plt.close(fig)
print('  %s  %d B' % (p4, os.path.getsize(p4)))

