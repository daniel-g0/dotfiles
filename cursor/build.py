#!/usr/bin/env python3
# Builds a NixOS cursor theme from the 󱄅 glyph in JetBrainsMono Nerd Font.

import os, subprocess, struct, zlib
from PIL import Image, ImageDraw, ImageFont

FONT = "/nix/store/s7wwsmqyscxqdxcdk26lznf9kaa7z0b5-nerd-fonts-jetbrains-mono-3.4.0+2.304/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf"
# Find actual font path
import glob
matches = glob.glob("/nix/store/*nerd-fonts-jetbrains*/**/JetBrainsMonoNerdFontMono-Regular.ttf", recursive=True)
if matches:
    FONT = matches[0]

GLYPH   = "\U000f1305"   # 󱄅 NixOS nerd font icon (U+F1305)
COLOR   = (122, 162, 247, 255)   # Tokyo Night blue #7aa2f7
OUTLINE = (26, 27, 38, 180)      # subtle dark outline
SIZES   = [24, 32, 48, 64]
OUT_DIR = "/tmp/NixCursor"
PNG_DIR = f"{OUT_DIR}/pngs"
CUR_DIR = f"{OUT_DIR}/cursors"

os.makedirs(PNG_DIR, exist_ok=True)
os.makedirs(CUR_DIR, exist_ok=True)

def render(size):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Load font sized to fill ~90% of the image
    font_size = int(size * 0.88)
    try:
        font = ImageFont.truetype(FONT, font_size)
    except Exception as e:
        print(f"Font load fail: {e}")
        return None

    # Measure glyph bounding box and center it
    bbox = font.getbbox(GLYPH)
    gw, gh = bbox[2] - bbox[0], bbox[3] - bbox[1]
    x = (size - gw) // 2 - bbox[0]
    y = (size - gh) // 2 - bbox[1]

    # Draw outline (offset 1px in each direction)
    for dx, dy in [(-1,0),(1,0),(0,-1),(0,1)]:
        draw.text((x+dx, y+dy), GLYPH, font=font, fill=OUTLINE)

    # Draw glyph in Tokyo Night blue
    draw.text((x, y), GLYPH, font=font, fill=COLOR)

    path = f"{PNG_DIR}/nix-{size}.png"
    img.save(path)
    print(f"  rendered {size}px → {path}")
    return path

# Render all sizes
print("Rendering glyphs...")
for s in SIZES:
    render(s)

# Write xcursorgen config: size hotspot_x hotspot_y file
cfg_path = f"{OUT_DIR}/nix.cursor"
with open(cfg_path, "w") as f:
    for s in SIZES:
        hx, hy = s // 2, s // 2   # hotspot = center
        f.write(f"{s} {hx} {hy} {PNG_DIR}/nix-{s}.png\n")

# Build cursor file
xcursorgen = "/nix/store/78c4rgfb812p5jz65fdr1q1irqsf6qih-xcursorgen-1.0.9/bin/xcursorgen"
cursor_out = f"{CUR_DIR}/default"
subprocess.run([xcursorgen, cfg_path, cursor_out], check=True)
print(f"  cursor → {cursor_out}")

# Symlink all standard cursor names to default
CURSOR_NAMES = [
    "left_ptr", "arrow", "top_left_arrow", "right_ptr",
    "hand1", "hand2", "pointing_hand", "grab", "grabbing",
    "crosshair", "cross", "plus", "watch", "wait",
    "text", "xterm", "ibeam",
    "size_all", "fleur", "move",
    "n-resize", "s-resize", "e-resize", "w-resize",
    "ne-resize", "nw-resize", "se-resize", "sw-resize",
    "ns-resize", "ew-resize", "nwse-resize", "nesw-resize",
    "col-resize", "row-resize",
    "not-allowed", "no-drop", "forbidden",
    "zoom-in", "zoom-out",
    "context-menu", "help", "copy", "alias",
    "progress", "all-scroll",
]
for name in CURSOR_NAMES:
    link = f"{CUR_DIR}/{name}"
    if not os.path.exists(link):
        os.symlink("default", link)

# Write theme files
with open(f"{OUT_DIR}/cursor.theme", "w") as f:
    f.write("[Icon Theme]\nName=NixCursor\n")

with open(f"{OUT_DIR}/index.theme", "w") as f:
    f.write("[Icon Theme]\nName=NixCursor\nComment=NixOS snowflake cursor — Tokyo Night blue\n")

print(f"\nDone! Theme at: {OUT_DIR}")
print(f"Install: cp -r {OUT_DIR} ~/.local/share/icons/NixCursor")
