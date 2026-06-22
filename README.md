<div align="center">

# ❄️ dotfiles

**NixOS · Hyprland · Tokyo Night — end-to-end**

[![NixOS](https://img.shields.io/badge/NixOS-flakes-5277C3?style=flat-square&logo=nixos&logoColor=white)](https://nixos.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-Lua-58E1FF?style=flat-square)](https://hyprland.org)
[![Tokyo Night](https://img.shields.io/badge/theme-Tokyo%20Night-7aa2f7?style=flat-square)](https://github.com/enkia/tokyo-night-vscode-theme)
[![License](https://img.shields.io/badge/license-MIT-bb9af7?style=flat-square)](LICENSE)

</div>

---

## Stack

| Layer | Tool | Notes |
|-------|------|-------|
| OS | **NixOS** (flakes) | Declarative, reproducible |
| Compositor | **Hyprland** | Lua config, animated borders |
| Shell | **Nushell** | Vi mode, SQLite history, structured data |
| Editor | **Neovim** (NvChad) | |
| Terminal | **Kitty** | Custom Python tab bar |
| Prompt | **Starship** | Single-line, icon-only |
| Status bar | **Waybar** | Modular jsonc + CSS |
| Lock screen | **Hyprlock** | Blurred wallpaper |
| Idle daemon | **Hypridle** | Dim → lock → suspend chain |
| Notifications | **swaync** | Slide-right panel, MPRIS widget |
| Wallpapers | **awww** + **WallRizz** | Daemon + fuzzy picker with theme sync |
| Launcher | **Jiffy** | kitty-based fzf launcher |
| Navigation | **Zoxide** + **FZF** | Smart jump, fuzzy everything |

---

---

## Install

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
./doller
```

`doller` is a Tokyo Night TUI installer. It shows the symlink status for every config, backs up any conflicts, then links everything into `~/.config`. On NixOS it also links system configs (requires sudo for `/etc/nixos`).

```bash
./doller --dry-run    # preview only — no changes made
./doller --force      # skip confirmation prompt
./install.sh          # shim that calls doller
```

After symlinking, rebuild NixOS to install all packages:

```bash
sudo nixos-rebuild switch
# or the alias:
nixos-re-sw
```

---

## Symlink map

| Repo path | Symlinked to |
|-----------|-------------|
| `nushell/` | `~/.config/nushell` |
| `nvim/` | `~/.config/nvim` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `kitty/` | `~/.config/kitty` |
| `wallpapers/` | `~/.config/wallpapers` |
| `jiffy/` | `~/.config/jiffy` |
| `wallrizz/` | `~/.config/WallRizz` |
| `wayland/hypr/` | `~/.config/hypr` |
| `wayland/swaync/` | `~/.config/swaync` |
| `wayland/waybar/` | `~/.config/waybar` |
| `nixos/configuration.nix` | `/etc/nixos/configuration.nix` |

> **Never edit `~/.config/*` directly** — they are symlinks. Edits land in the repo automatically.

---

## Structure

```
dotfiles/
├── doller                        TUI symlink installer
├── install.sh                    shim → doller
├── nixos/
│   ├── configuration.nix         system packages, services, custom derivations
│   └── hardware-configuration.nix
├── nushell/
│   ├── config.nu                 shell config, hooks, FZF, env vars
│   ├── aliases/                  alias modules
│   │   ├── bat/
│   │   ├── docker/               35+ aliases
│   │   ├── git/                  150+ aliases + helpers
│   │   ├── nixos/
│   │   ├── nvim/
│   │   ├── rip/
│   │   └── utils/
│   └── custom-completions/       completions for 15+ tools
├── starship/
│   └── starship.toml
├── kitty/
│   ├── kitty.conf
│   └── tab_bar.py                custom Python tab bar renderer
├── wallpapers/                   wallpaper images (Tokyo Night palette)
├── wallrizz/
│   ├── launch.sh                 kitty launcher script
│   ├── awww@daniel.js            daemon handler (awww transitions)
│   ├── color-backend.sh          ImageMagick 16-color palette extractor
│   └── themeExtensionScripts/
│       ├── kitty@5hubham5ingh.js kitty theme sync
│       └── hyprland@daniel.js    Hyprland border color sync
├── jiffy/
│   └── launch.sh
├── wayland/
│   ├── hypr/
│   │   ├── hyprland.lua          compositor (Lua API)
│   │   ├── hyprlock.conf         lock screen
│   │   └── hypridle.conf         idle/suspend timers
│   ├── waybar/
│   │   ├── config.jsonc          bar layout (includes modular jsonc)
│   │   ├── style.css             main stylesheet
│   │   ├── modules/              per-module jsonc definitions
│   │   │   └── custom/           custom scripts: user, distro, notifications, update, power, dividers
│   │   ├── menus/                GTK XML menus (nix ops, power)
│   │   ├── scripts/              shell scripts (volume, brightness)
│   │   └── styles/               modular CSS partials
│   └── swaync/
│       ├── config.json
│       └── style.css
└── fastfetch/                    fastfetch config
```

---

## NixOS

[![NixOS](https://img.shields.io/badge/NixOS-24.11-5277C3?style=flat-square&logo=nixos)](https://nixos.org)

Config at `nixos/configuration.nix` — single file, flakes enabled.

### System
- **Boot:** systemd-boot, quiet splash, latest kernel, max 3 generations
- **Audio:** PipeWire + PulseAudio compat layer + ALSA 32-bit + RTKit realtime
- **Display:** Hyprland session, X server + dconf + polkit
- **Input:** Capslock → Escape via `keyd`, Spanish layout (`es`)
- **Docker:** rootless mode
- **Network:** NetworkManager, hostname `nixos`
- **Locale:** `en_US` / `es_ES` regional / `Europe/Madrid` timezone
- **Shell:** bash auto-launches nushell for interactive sessions

### Custom packages (auto-patched ELF)
| Package | Version | Source |
|---------|---------|--------|
| jiffy | 1.6.3 | GitHub release binary |
| wallrizz | 1.4.0 | GitHub release binary |

Both use `autoPatchelfHook` — NixOS patches the ELF interpreter and rpath automatically so the binaries work without FHS.

### Notable packages
```
Wayland:  hyprlock hypridle awww waybar swaync hyprpicker blueman
          fastfetch fortune fzf
Terminal: kitty starship zoxide yazi bat ripgrep fd delta btop dust rm-improved
Dev:      neovim git git-lfs gcc uv nodejs claude-code
Apps:     brave teams-for-linux keepass veracrypt
Fonts:    JetBrainsMono Nerd Font, Material Icons
```

---

## Hyprland

[![Hyprland](https://img.shields.io/badge/Hyprland-Lua%20API-58E1FF?style=flat-square)](https://hyprland.org)

Config at `wayland/hypr/hyprland.lua` — uses the Hyprland Lua API.

### Appearance

| Property | Value |
|----------|-------|
| Theme | Tokyo Night |
| Gaps | in: 5px · out: 20px |
| Border | 3px |
| Rounding | 10px / power 2 |
| Active border | Animated gradient: blue `#7aa2f7` → purple `#bb9af7` → cyan `#2ac3de` · loops |
| Inactive border | `#414868` at 66% opacity |
| Shadow | `#7aa2f7` 22% active · `#1a1b26` 12% inactive · range 6px |
| Blur | 16px · 6 passes · vibrancy 0.3 · noise 0.02 |
| Opacity | 100% active + inactive (per-app via window rules) |

### Autostart
```
kitty · waybar · swaync · hypridle
awww-daemon → nix-tokyo-night.png (2s fade transition)
```

### Keybindings

| Binding | Action |
|---------|--------|
| `Super + Return` | Open kitty terminal |
| `Super + Q` | Close focused window |
| `Super + F` | File manager (yazi in kitty) |
| `Super + E` | Jiffy app launcher |
| `Super + W` | WallRizz wallpaper picker |
| `Super + N` | Toggle swaync notification center |
| `Super + T` | Toggle dwindle split |
| `Super + Shift + L` | Lock screen (hyprlock) |
| `Super + Shift + R` | Reload Hyprland config |
| `Super + Shift + S` | Region screenshot → clipboard |
| `Print` | Full screenshot → `~/Pictures/YYYYMMDD_HHMMSS.png` |
| `Super + H/L/K/J` | Focus left / right / up / down |
| `Super + [1–9, 0]` | Switch to workspace |
| `Super + Shift + [1–9, 0]` | Move window to workspace |
| `Super + Scroll` | Cycle workspaces |
| `Super + LMB drag` | Move window |
| `Super + RMB drag` | Resize window |
| `XF86AudioRaiseVolume` | Volume +5% (repeating) |
| `XF86AudioLowerVolume` | Volume −5% (repeating) |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle mic mute |
| `XF86MonBrightnessUp/Down` | Brightness ±5% (brightnessctl) |
| `XF86AudioNext/Prev/Play/Pause` | Playerctl |

### Gestures
- **3-finger horizontal swipe** → switch workspace

### Window rules
| Rule | Match | Effect |
|------|-------|--------|
| Suppress maximize | all windows | Ignores maximize requests |
| Fix XWayland drags | class `^$`, xwayland float | `no_focus` |
| Jiffy | class `jiffy` | Float · 700×500 · centered |
| WallRizz | class `wallrizz` | Float · 900×600 · centered |

### Input
- Keyboard: Spanish layout (`es`) via Hyprland, Capslock → Escape via `keyd`
- Touchpad: natural scroll off
- Mouse sensitivity: 0 (no modification)

---

## Hyprlock

Config at `wayland/hypr/hyprlock.conf`.

- **Background:** blurred current wallpaper (8px, 3 passes) with `#1a1b26` fallback
- **Clock:** 72pt bold · `HH:MM` · 1s refresh
- **Date:** 18pt · `Day, Month DD` · 60s refresh
- **Password field:** 300×50px · blue border `#7aa2f7` · centered (−80px vertical offset)
- No loading bar · cursor hidden · no grace period

---

## Hypridle

Config at `wayland/hypr/hypridle.conf`.

| Timeout | Action |
|---------|--------|
| 5 min | Dim to 20% brightness (`brightnessctl`) |
| 10 min | Lock session (`loginctl lock-session`) |
| 11 min | Turn off display (`hyprctl dispatch dpms off`) |
| 30 min | Suspend system (`systemctl suspend`) |

Before suspend → lock. After wake → display on.

---

## Waybar

[![Waybar](https://img.shields.io/badge/Waybar-modular-F5C2E7?style=flat-square)](https://github.com/Alexays/Waybar)

Config at `wayland/waybar/` — modular jsonc split by module, modular CSS split by section.

Layer: **top** · Mode: **dock** · Auto-reload on CSS change.

### Layout

**Left:**
`󰍜 NixOS menu` · `󱄅 Distro logo` · `CPU %` · `RAM %` · `Temp °C`

**Center:**
`Clock HH:MM` · `Date DD-MM` (with calendar popup)

**Right:**
`Idle inhibitor` · `Network` · `Bluetooth` · `Notifications` · `Updates` · `MPRIS` · `Volume` · `Mic` · `Backlight` · `Battery` · `󰍜 Power menu`

### Module details

#### 󰍜 NixOS menu (`custom/user`)
GTK dropdown — all actions open a dedicated kitty window, tee output to `/tmp/nix-<action>.log`, and wait for Enter before closing:

| Entry | Command |
|-------|---------|
| Edit config | `nvim /etc/nixos/configuration.nix` |
| Rebuild Switch | `nixos-rebuild switch` |
| Rebuild Test | `nixos-rebuild test` |
| Update Flake | `nix flake update` |
| Garbage Collect | `nix-collect-garbage --delete-older-than 7d` |
| List Generations | `nixos-rebuild list-generations` |

#### 󱄅 Distro logo (`custom/distro`)
Opens kitty in `$HOME` with `NU_BANNER=1` → triggers fastfetch + centered fortune "Quote of the Day" greeting.

#### Temperature
CPU temp · critical threshold: **90°C**

#### Memory
RAM usage % · tooltip: used / total GiB

#### CPU
Usage % · updates every 10s · warn: 75% · critical: 90%

#### Clock
- `clock#time` — `HH:MM` · tooltip: 12h AM/PM format
- `clock#date` — `DD-MM` · click: calendar popup

#### Network
WiFi signal strength bars · tooltip: SSID, IP, frequency · click: network manager menu · right-click: toggle WiFi

#### Bluetooth
Connected device + battery % in tooltip · click: bluetooth manager menu

#### Notifications (`custom/notifications`)
swaync integration — icon changes per state: normal / DND / inhibited

#### Updates (`custom/update`)
Hourly package check · click: update TUI in kitty · right-click: refresh

#### Idle inhibitor
Toggle prevent-screen-sleep; icon changes when active

#### MPRIS
Current track: `title - artist`

#### PulseAudio (group)
- Output: volume % · scroll ±5% · click: mute toggle · tooltip: device name
- Input: mic level · muted state · scroll to adjust

#### Backlight
Brightness % · scroll to adjust

#### Battery
% + charging icon · notify-send at 20% (warn), 10% (critical), 100% (full)

#### Power menu (`custom/power`)
GTK dropdown: Lock / Suspend / Hibernate / Reboot / Shutdown / Logout

### Styling
Tokyo Night palette throughout. Buttons: 20px border-radius. Powerline dividers between module groups. Frosted look via Hyprland blur on the layer.

---

## Nushell

[![Nushell](https://img.shields.io/badge/Nushell-vi%20mode-4E9A06?style=flat-square&logo=powershell&logoColor=white)](https://nushell.sh)

Config at `nushell/config.nu`.

Vi mode — block cursor in normal, line cursor in insert. Indicators: `󱄅 N` (normal) / `󱄅 I` (insert). History: SQLite, 100k entries, per-session, deduped, timestamps, auto-sync on every entry.

### Hooks

| Hook | Trigger | Action |
|------|---------|--------|
| Tab bar title | Every prompt | Updates kitty tab title: `~/path 󰊢 branch [+N ~N ?N] \| Nf Nd` |
| Auto-clear | Directory change | Clears screen on `cd` to any non-home directory (scrollback preserved) |
| Greeting | Shell start | fastfetch + centered fortune; only when `NU_BANNER=1` is set (waybar logo launch) |

### FZF keybinds

| Key | Action |
|-----|--------|
| `Ctrl+R` | Fuzzy history search |
| `Ctrl+T` | Fuzzy file picker → insert path (fd-powered) |
| `Alt+C` | Fuzzy `cd` to directory |

### Alias modules

| Module | Key aliases |
|--------|-------------|
| `bat` | `b`, `bn` (numbered), `bp` (plain), `bl` |
| `docker` | 35+ aliases — build, image, container, network, volume; `dsta` (stop all) |
| `git` | 150+ aliases + helpers (`git_current_branch`, `git_main_branch`, worktree, rebase flows) |
| `nixos` | `nixos-edit`, `nixos-re-sw` (rebuild switch), `nixos-garbage` (7d+ cleanup) |
| `nvim` | `n` → `nvim` |
| `rip` | `rm` → rip (trash, recoverable), `rd` (restore deleted) |
| `utils` | `grep`→rg · `find`→fd · `du`→dust · `top`→btop · `cb` (wl-copy) · `cbp` (wl-paste) |

### Custom completions
bat · docker · gh · git · less · make · man · nix · ssh · tar · tldr · uv · zoxide · and more

---

## Kitty

[![Kitty](https://img.shields.io/badge/Kitty-terminal-F5A97F?style=flat-square)](https://sw.kovidgoyal.net/kitty/)

Config at `kitty/kitty.conf`.

| Setting | Value |
|---------|-------|
| Font | JetBrainsMono Nerd Font 12pt |
| Theme | Tokyo Night |
| Opacity | 75% |
| Blur | Frosted (via Hyprland window rule) |
| Scrollback | 10,000 lines |
| Padding | 8px |
| Cursor | Block, no blink |
| Repaint | 10ms |
| Input delay | 3ms |
| Remote control | Unix socket `/tmp/kitty` |

### Custom tab bar (`tab_bar.py`)

Pure Python renderer. Parses the nushell pre-prompt title (`~/path 󰊢 branch [+1 ~2] | 5f 2d | 14:23`) and renders:

| Mode | Rendering |
|------|-----------|
| Single tab | Title centered full-width |
| Multi-tab | Segments: directory (blue `#7aa2f7`) · branch (purple `#bb9af7`) · file counts (cyan `#7dcfff`) · time (green `#9ece6a`) |

Background: `#1a1b26` (Tokyo Night storm base)

---

## Starship

[![Starship](https://img.shields.io/badge/Starship-prompt-DD0B78?style=flat-square&logo=starship&logoColor=white)](https://starship.rs)

Config at `starship/starship.toml`. Single-line, no newline.

- **Left:** Language icons — C · Python · Node · Rust · Go · Java · Docker — appear only inside matching project directories
- **Right:** Username — purple `#bb9af7` normally, red `#f7768e` for root
- No `cmd_duration`, no directory segment, no git in starship — handled by the nushell pre-prompt hook and kitty tab bar

### Git status symbols
`⇡N` ahead · `⇣N` behind · `⇕` diverged · `~` conflicted · `*` stashed · ` ` modified · `++N` staged · `?` untracked · ` ` deleted

---

## WallRizz

[![WallRizz](https://img.shields.io/badge/WallRizz-wallpaper%20picker-7aa2f7?style=flat-square)](https://github.com/5hubham5ingh/WallRizz)

Config at `wallrizz/`. Triggered by `Super+W`.

### How it works
1. Opens as a floating kitty window (class `wallrizz`, 900×600, centered, 90% opacity)
2. fzf list with live image preview via `timg`
3. On selection: `awww-daemon` applies the wallpaper with a random transition (fade / wipe / wave / grow / center / outer) at 60fps, 1s duration
4. Color backend (`color-backend.sh`) extracts 16 hex colors per image via ImageMagick k-means clustering
5. Theme extensions update kitty colors and Hyprland border gradient live

### Components

| File | Purpose |
|------|---------|
| `launch.sh` | Kitty launcher |
| `awww@daniel.js` | Daemon handler — random `awww` transitions |
| `color-backend.sh` | 16-color palette extractor (ImageMagick, always pads to exactly 16) |
| `themeExtensionScripts/kitty@5hubham5ingh.js` | Live kitty color sync via remote control |
| `themeExtensionScripts/hyprland@daniel.js` | Live Hyprland border gradient sync via `hyprctl keyword` |

### Wallpapers
```
nix-tokyo-night.png   dark-logo.jpg    foggy-forest.jpg
tokyo-water.jpg       lava-bw.jpg      win10-dark.jpg
win10-purple.png      win11-wall.jpg   win-bw.webp
```

---

## Jiffy

[![Jiffy](https://img.shields.io/badge/Jiffy-launcher-9ece6a?style=flat-square)](https://github.com/5hubham5ingh/jiffy)

Config at `jiffy/launch.sh`. Triggered by `Super+E`.

fzf-powered application launcher running inside kitty. Single-instance (kitty `-1`). Tokyo Night fzf colors. Floats centered at 700×500 via Hyprland window rule (class `jiffy`).

---

## swaync

[![swaync](https://img.shields.io/badge/swaync-notifications-f7768e?style=flat-square)](https://github.com/ErikReider/SwayNotificationCenter)

Config at `wayland/swaync/`. Triggered by `Super+N` or clicking the waybar notification icon.

| Setting | Value |
|---------|-------|
| Position | Top-right |
| Width | 400px |
| Control center size | 400×600 |
| Open animation | Slide-right · 200ms |
| Close animation | 100ms |
| Default timeout | 5s |
| Low timeout | 3s |
| Critical timeout | 0 (sticky) |

**Widgets:** Title bar + clear-all · DND toggle · Notifications list · MPRIS player (72px rounded album art)

Keyboard shortcuts enabled. Waybar module reflects DND and inhibited states with distinct icons.

---

## Philosophy

Every tool in this setup follows the same three principles:

1. **Vi keys everywhere.** Nushell vi mode, Hyprland `hjkl` focus, Neovim. If you need arrow keys for navigation, wrong repo.

2. **Tokyo Night end-to-end.** One palette (`#1a1b26` base, `#7aa2f7` blue, `#bb9af7` purple, `#7dcfff` cyan, `#9ece6a` green, `#f7768e` red) used in every tool — terminal, bar, compositor borders, lock screen, notifications, launcher.

3. **NixOS or bust.** All packages declared, all configs symlinked, one `nixos-rebuild switch` away from a working system. No manual installs, no stale state.
