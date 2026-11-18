# Theming

Dynamic palette (`apply-theme`), presets, and WallRizz wallpapers.

## Theming

`Super+Shift+P` (`select-theme`, fzf over presets) or WallRizz (wallpaper) → `shell/scripts/apply-theme`, which writes a palette (`~/.cache/dynamic-theme/palette.json`: bg, bg_alt, fg, fg_dim, accent, blue, cyan, green, red, yellow) and regenerates every app's colours. Presets live in `PRESETS` in `apply-theme` and are listed in `select-theme` (name + swatch preview) — add both. Current extras: `redline` (black/red), `monochrome` (black/white).

Applied to: waybar (CSS + icon spans), kitty (+ tab bar), swaync, rofi, cava, btop, starship, Hyprland borders/shadow, fastfetch, yazi, hyprlock, cheatsheet, nix-menu, nushell + fzf (`themes/dynamic.nu`, generated from `tokyo-night.nu`), nvim, Claude Code statusline, whosthere and the rofi/waybar scripts (`RECOLOR_FILES`). Brave is skipped (extension theming isn't reliable).

Gotchas:
- **nvim:** `chadrc.lua` needs `theme` under `M.base46`, not `M.ui` (otherwise NvChad ignores it and shows onedark). The colours actually shown come from tokyonight fed by `dev/nvim/lua/palette.lua`; `plugins/init.lua` forces that colorscheme over base46. `apply-theme` also recompiles base46's cache and calls `require("palette").reload()` in every running nvim (`$XDG_RUNTIME_DIR/nvim.*.0`).
- **kitty:** `listen_on` appends the PID, so sockets are `/tmp/kitty-<pid>`; `apply-theme` globs them. Plain `/tmp/kitty` never exists.
- **Recolouring is hex-to-hex** (`_role_map`): old = original Tokyo Night value + previous palette. Two roles sharing one hex inside a preset (rose-pine, dracula, monokai, everforest, horizon, crimson do) collide when switching away from it. Keep new presets' roles distinct.
- Waybar icon colours are CSS (`@accent`/`@blue`/`@cyan` in `style.css`), not hex spans, so they follow any theme; green/yellow/red are reserved for warning/critical/connected states. Icon sizes are per-icon (`style.css`, measured so every glyph fits the same ~17.5px box).
- nushell reads its theme at shell start; already-open shells keep the old colours.

---

## WallRizz

**Config:** `wallrizz/`

- Kitty window, class `wallrizz`, 90% opacity, lists `~/.config/wallpapers`
- `awww@daniel.js`: random transitions (fade/wipe/wave/grow/center/outer), 1s duration, 60fps, random position
- `color-backend.sh`: ImageMagick kmeans extraction of 16 hex colors per image for theme sync

### Animated wallpapers (researched, NOT applied)

Wanted eventually; deliberately not implemented yet. Findings so you don't redo the research:

- **GIF works today, nothing to install.** `awww` 0.12.1 (the daemon already running) animates GIFs natively: `awww img file.gif`. Limits: 256 colours, CPU cost while it plays, big GIFs use a lot of RAM (awww keeps the frames).
- **Video (mp4/webm) needs `mpvpaper`** — 1.9 in nixpkgs, not installed; `mpv` already is. Full colour, GPU decode, loops. It is its own background-layer surface, so it would run next to `awww-daemon` (start it after awww; kill it to get the static wallpaper back). It has options to pause/stop when the wallpaper is hidden — check `mpvpaper --help` before relying on them. Not tried here.
- **Conversion helpers, not installed:** `ffmpeg` 9.0.1 and `gifsicle` 1.96 are in nixpkgs.
- **Things to touch when applying it:**
  1. `apps/wallrizz/awww@daniel.js` runs `awww img <path>` — fine for GIFs if WallRizz lists `.gif` (not checked); video needs a branch that starts mpvpaper instead.
  2. `apps/wallrizz/color-backend.sh` extracts colours with ImageMagick — for a GIF read the first frame (`file.gif[0]`); for video grab a frame with ffmpeg first. Theme sync needs a still.
  3. `hyprland.lua` autostart sets the static wallpaper with `awww img` (≈ line 96); a video wallpaper needs an mpvpaper exec there to survive login.
  4. hyprlock paints the *current wallpaper* blurred, so it would show a single frame.
  5. Animated = constant CPU/GPU use: pause it on battery / when idle (a hypridle hook).
- **Repo size:** wallpapers live in `wm/wallpapers/` (~47 MB, all stills, stored in git-lfs — see "Git LFS" in [repo.md](repo.md)). Videos/GIFs would bloat the repo quickly: add `*.gif`/`*.mp4`/`*.webm` to `.gitattributes` *before* the first commit of one, or keep them out of the repo.
