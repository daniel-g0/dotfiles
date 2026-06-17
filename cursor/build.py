#!/usr/bin/env python3
# Builds a NixOS cursor from the official NixOS snowflake SVG (nixos-artwork repo).
# Recolors to Tokyo Night blue (#7aa2f7) before rendering.
# Run: nix-shell -p librsvg --run 'python3 cursor/build.py'

import os, re, subprocess, glob, shutil, urllib.request

SVG_URL    = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg"
TOKYO_BLUE = "#7aa2f7"

SIZES   = [24, 32, 48, 64]
# Output directly into the repo so built files can be committed and reused.
# install.sh symlinks ~/.config/cursors → dotfiles/cursor/, making it live from there.
OUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "nix-logo")
PNG_DIR = f"{OUT_DIR}/pngs"
CUR_DIR = f"{OUT_DIR}/cursors"

os.makedirs(PNG_DIR, exist_ok=True)
os.makedirs(CUR_DIR, exist_ok=True)

# Download official SVG
svg_raw = f"{OUT_DIR}/nix-snowflake.svg"
print(f"Downloading NixOS snowflake SVG...")
urllib.request.urlretrieve(SVG_URL, svg_raw)

# Recolor all hex colors → Tokyo Night blue
with open(svg_raw) as f:
    svg = f.read()
svg = re.sub(r'#[0-9a-fA-F]{6}', TOKYO_BLUE, svg)
svg = re.sub(r'#[0-9a-fA-F]{3}\b', TOKYO_BLUE, svg)

svg_colored = f"{OUT_DIR}/nix-snowflake-tokyo.svg"
with open(svg_colored, "w") as f:
    f.write(svg)

# Render PNGs with rsvg-convert
print("Rendering PNGs...")
for size in SIZES:
    out = f"{PNG_DIR}/nix-{size}.png"
    subprocess.run(["rsvg-convert", "-w", str(size), "-h", str(size), svg_colored, "-o", out], check=True)
    print(f"  {size}px → {out}")

# xcursorgen config
cfg_path = f"{OUT_DIR}/nix.cursor"
with open(cfg_path, "w") as f:
    for s in SIZES:
        f.write(f"{s} {s//2} {s//2} {PNG_DIR}/nix-{s}.png\n")

# Find xcursorgen
xcursorgen = shutil.which("xcursorgen")
if not xcursorgen:
    matches = glob.glob("/nix/store/*xcursorgen*/bin/xcursorgen")
    xcursorgen = matches[0] if matches else None
if not xcursorgen:
    raise RuntimeError("xcursorgen not found — run: nix-shell -p xorg.xcursorgen")

cursor_out = f"{CUR_DIR}/default"
subprocess.run([xcursorgen, cfg_path, cursor_out], check=True)
print(f"  cursor → {cursor_out}")

# Symlinks
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
    if os.path.exists(link) or os.path.islink(link):
        os.remove(link)
    os.symlink("default", link)

with open(f"{OUT_DIR}/cursor.theme", "w") as f:
    f.write("[Icon Theme]\nName=NixCursor\n")
with open(f"{OUT_DIR}/index.theme", "w") as f:
    f.write("[Icon Theme]\nName=NixCursor\nComment=NixOS snowflake cursor — Tokyo Night blue\n")

print(f"\nDone! Files at: {OUT_DIR}")
print(f"  Run install.sh to symlink ~/.config/cursors → dotfiles/cursor/")
print(f"  Then: hyprctl setcursor NixCursor 24")
