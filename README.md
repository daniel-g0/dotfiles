# dotfiles

Personal NixOS + Hyprland dotfiles. Tokyo Night themed end-to-end. Everything symlinked to `~/.config` via `install.sh`.

---

## Stack

| Tool | Purpose |
|------|---------|
| NixOS (flakes) | OS + package management |
| Hyprland | Wayland compositor (Lua config) |
| Nushell | Shell (vi mode) |
| Neovim (NvChad) | Editor |
| Kitty | Terminal (custom Python tab bar) |
| Starship | Prompt |
| Waybar | Status bar (modular jsonc) |
| Hyprlock | Lock screen |
| Hypridle | Idle/suspend daemon |
| swaync | Notification center |
| awww | Wallpaper daemon |
| WallRizz | Wallpaper picker + theme sync |
| Jiffy | Application launcher |
| Zoxide | Smart directory jumping |
| FZF | Fuzzy finder (history, files, dirs) |

---

## Install

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
./doller
```

`doller` is a TUI installer — shows symlink status for every config, backs up conflicts, then links everything into `~/.config`. On NixOS it also links system configs (requires sudo).

```
./doller --dry-run   # preview only, no changes
./doller --force     # skip confirmation prompt
```

Then rebuild NixOS to install all packages:

```bash
nixos-re-sw
# or: sudo nixos-rebuild switch
```

---

## Structure

```
dotfiles/
├── nushell/                  → ~/.config/nushell
│   ├── config.nu               shell config, hooks, FZF, greeting
│   ├── aliases/                alias modules (git, docker, nixos, utils…)
│   └── custom-completions/     completions for 15+ tools
├── nvim/                     → ~/.config/nvim
├── starship/starship.toml    → ~/.config/starship.toml
├── kitty/                    → ~/.config/kitty
│   ├── kitty.conf              terminal config
│   └── tab_bar.py              custom tab bar renderer
├── wallpapers/               → ~/.config/wallpapers
├── wallrizz/                 → ~/.config/wallrizz
├── jiffy/                    → ~/.config/jiffy
├── wayland/
│   ├── hypr/                 → ~/.config/hypr
│   │   ├── hyprland.lua        compositor (Lua)
│   │   ├── hyprlock.conf       lock screen
│   │   └── hypridle.conf       idle timers
│   ├── waybar/               → ~/.config/waybar
│   │   ├── modules/            per-module jsonc files
│   │   ├── menus/              GTK XML menus (nix, power)
│   │   └── styles/             modular CSS
│   └── swaync/               → ~/.config/swaync
└── nixos/
    ├── configuration.nix     → /etc/nixos/configuration.nix
    └── hardware-configuration.nix
```

---

## Nushell

Vi mode shell with structured data. History in SQLite (100k, deduped). Zoxide for directory jumping.

### Hooks
- **Tab bar title** — updates every prompt: `~/path  branch [+staged ~modified ?untracked] | Nf Nd`
- **Auto-clear on cd** — clears screen when entering any non-home directory (scrollback preserved)
- **Greeting** — fastfetch + centered fortune quote; only shows when kitty is launched from the waybar NixOS logo

### FZF keybinds
| Key | Action |
|-----|--------|
| `Ctrl+R` | Fuzzy history search |
| `Ctrl+T` | Fuzzy file picker → insert path |
| `Alt+C` | Fuzzy cd to directory |

### Alias highlights
- `rm` → `rip` (trash, recoverable via `rd`)
- `grep` → `ripgrep`, `find` → `fd`, `du` → `dust`, `top` → `btop`
- `cb` / `cbp` → wl-copy / wl-paste
- `n` → `nvim`
- `nixos-re-sw` → `sudo nixos-rebuild switch`
- 150+ git aliases with branch, rebase, worktree, stash helpers
- 35+ docker aliases

---

## Kitty

JetBrainsMono Nerd Font 12pt. Tokyo Night colors. 75% opacity + frosted blur via Hyprland.

**Custom tab bar** (`tab_bar.py`) parses the nushell title and renders colored segments:
- Single tab: title centered full-width
- Multi-tab: directory (blue) · branch (purple) · file counts (cyan) · time (green)

---

## Hyprland

Lua-based config. Liquid animated border on active windows (blue→purple→cyan gradient).

### Keybindings

| Bind | Action |
|------|--------|
| `Super+Return` | Terminal (kitty) |
| `Super+Q` | Close window |
| `Super+F` | File manager (yazi in kitty) |
| `Super+E` | Jiffy app launcher |
| `Super+W` | WallRizz wallpaper picker |
| `Super+N` | Toggle notification center |
| `Super+T` | Toggle dwindle split |
| `Super+Shift+L` | Lock screen |
| `Super+Shift+R` | Reload config |
| `Super+Shift+S` | Region screenshot → clipboard |
| `Print` | Full screenshot → `~/Pictures/` |
| `Super+H/L/K/J` | Focus left/right/up/down |
| `Super+[1-9]` | Switch workspace |
| `Super+Shift+[1-9]` | Move window to workspace |
| `Super+Scroll` | Cycle workspaces |
| `Super+LMB drag` | Move window |
| `Super+RMB drag` | Resize window |
| `XF86Audio*` | Volume/mic (wpctl) |
| `XF86Brightness*` | Brightness (brightnessctl) |
| `XF86Audio Play/Next/Prev` | Playerctl |

### Gestures
- 3-finger horizontal swipe → workspace switch

### Idle / lock sequence (hypridle)

| Time | Action |
|------|--------|
| 5 min | Dim to 20% brightness |
| 10 min | Lock (hyprlock) |
| 11 min | Display off |
| 30 min | Suspend |

---

## Waybar

Modular status bar. Top dock, full width.

### Left
- **󰍜 NixOS menu** — GTK dropdown for NixOS ops:
  - Edit config (opens in nvim)
  - Rebuild Switch / Rebuild Test
  - Update Flake
  - Garbage Collect (7d+)
  - List Generations
  - All actions open kitty, tee output to `/tmp/nix-<action>.log`, wait Enter to close

### Center
Temperature · Memory · CPU · **󱄅 Distro logo** · Clock · Date · Network · Bluetooth · Notifications · Updates · Idle inhibitor

> Clicking 󱄅 opens kitty with the fastfetch + fortune greeting

### Right
MPRIS track · Volume (output) · Microphone · Backlight · Battery · Power menu (lock/suspend/hibernate/reboot/shutdown/logout)

---

## WallRizz

Fuzzy wallpaper picker in kitty. Selects from `~/.config/wallpapers`, applies via awww daemon with random transitions (fade/wipe/wave/grow/center/outer, 1s, 60fps). Color backend extracts 16-color palette per image via ImageMagick for theme sync.

---

## Swaync

Notification center, top-right. Slide-right animation. Timeouts: 5s default, 3s low, sticky critical. Includes MPRIS widget with album art.

---

## NixOS

Flakes enabled. Notable system setup:
- Boot: systemd-boot, quiet, latest kernel, max 3 generations
- Audio: PipeWire + PulseAudio compat
- Capslock → Escape (keyd)
- Keyboard layout: Spanish (es)
- Docker rootless
- Shell: bash auto-launches nushell for interactive sessions
- Custom packages: jiffy v1.6.3, wallrizz v1.4.0

---

## Philosophy

Everything vim-keybinding based. Nushell in vi mode, Hyprland with hjkl focus, Neovim obviously. If you need arrow keys, wrong repo.
