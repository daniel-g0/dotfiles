# CLAUDE.md

## Repo

Personal dotfiles. Files in this repo are the source of truth — `~/.config/*` are symlinks pointing here. Theme: Tokyo Night across all tools.

## Symlink map

| Repo path | Symlinked to |
|-----------|-------------|
| `nushell/` | `~/.config/nushell` |
| `nvim/` | `~/.config/nvim` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `kitty/` | `~/.config/kitty` |
| `wallpapers/` | `~/.config/wallpapers` |
| `jiffy/` | `~/.config/jiffy` |
| `wallrizz/` | `~/.config/wallrizz` |
| `wayland/hypr/` | `~/.config/hypr` |
| `wayland/swaync/` | `~/.config/swaync` |
| `nixos/configuration.nix` | `/etc/nixos/configuration.nix` (sudo) |
| `nixos/hardware-configuration.nix` | `/etc/nixos/hardware-configuration.nix` (sudo) |

Run `bash install.sh` to (re)create all symlinks. Safe to re-run.

---

## Nushell

**Config:** `nushell/config.nu` | **Aliases:** `nushell/aliases/<tool>/<tool>-aliases.nu`

### Shell behavior
- Vi mode — block cursor in normal, line in insert; `󱄅 N` / `󱄅 I` indicators
- History: SQLite, 100k entries, per-session, dedup, timestamps, auto-sync on entry
- Zoxide smart directory jumping (`z`, `zi`)
- `$EDITOR` / `$VISUAL` / `buffer_editor` all set to `nvim`

### Hooks
- **Pre-prompt title:** Updates kitty tab bar every prompt: `~/path 󰊢 branch [+staged ~modified ?untracked] | Nf Nd`
- **PWD change:** Auto-clears screen on `cd` to any non-home directory
- **Greeting:** Fastfetch + centered fortune "Quote of the Day" — only fires when `NU_BANNER=1` is in env (set by waybar distro logo kitty launch)

### FZF keybinds
| Key | Action |
|-----|--------|
| `Ctrl+R` | Fuzzy history search |
| `Ctrl+T` | Fuzzy file picker → insert path (fd-powered) |
| `Alt+C` | Fuzzy cd to directory |

### Alias modules
| Module | Key aliases |
|--------|-------------|
| `bat` | `b`, `bn` (numbered), `bp` (plain), `bl` |
| `docker` | 35+ aliases — build, image, container, network, volume; `dsta` (stop all) |
| `git` | 150+ aliases + helpers (`git_current_branch`, `git_main_branch`, worktree, rebase flows) |
| `nixos` | `nixos-edit`, `nixos-re-sw` (rebuild switch), `nixos-garbage` (7d+ cleanup) |
| `nvim` | `n` |
| `rip` | `rm` → rip (trash), `rd` (restore deleted) |
| `utils` | `grep`→rg, `find`→fd, `du`→dust, `top`→btop, `cb` (copy), `cbp` (paste) |
| `chezmoi` | `ch`, `chad`, `chap`, `chd`, `chda`, `chs` |

### Custom completions
Bat, Docker, GitHub CLI, Git, Less, Make, Man, Nix, SSH, Tar, tldr, uv, Zoxide

---

## Starship

**Config:** `starship/starship.toml`

- Single-line, no newline
- **Left:** Language icons (C, Python, Node, Rust, Go, Java, Docker) — appear only in matching project dirs
- **Right:** Username (purple `#bb9af7`; red `#f7768e` for root)
- No cmd_duration, no directory/git in starship (handled by nushell pre-prompt hook + kitty tab bar)

### Git status symbols
`⇡N` ahead · `⇣N` behind · `⇕` diverged · `~` conflicted · `*` stashed · ` ` modified · `++N` staged · `?` untracked · ` ` deleted

---

## Kitty

**Config:** `kitty/kitty.conf` | **Tab bar:** `kitty/tab_bar.py`

- Font: JetBrainsMono Nerd Font 12pt
- Tokyo Night colors, 75% opacity, frosted blur (via Hyprland window rule)
- Scrollback: 10,000 lines; padding 8px; block cursor, no blink
- Repaint 10ms, input delay 3ms, sync to monitor
- Remote control via Unix socket `/tmp/kitty`

### Custom tab bar (`tab_bar.py`)
Parses nushell pre-prompt title (`~/path 󰊢 branch [+1 ~2] | 5f 2d | 14:23`):
- **Single tab:** Title centered full-width
- **Multi-tab:** Segments — directory (blue), branch (purple), file counts (cyan), time (green)
- Colors: bg `#1a1b26`, blue `#7aa2f7`, purple `#bb9af7`, cyan `#7dcfff`, green `#9ece6a`

---

## Hyprland

**Config:** `wayland/hypr/hyprland.lua` (Lua-based)

### Autostart
`kitty`, `waybar`, `swaync`, `hypridle`, `awww-daemon` (wallpaper: `Nix Tokyo Night.png`, 2s fade)

### Appearance
- Gaps: in 5px / out 20px; border 3px; rounding 10px
- Active border: liquid gradient blue→purple→cyan (animated, angle loops)
- Inactive border: `#414868` 66% opacity
- Shadow: `#7aa2f7` 22% / inactive `#1a1b26` 12%
- Blur: 16px, 6 passes, vibrancy 0.3

### Keybindings (Super key)
| Binding | Action |
|---------|--------|
| `Super+Return` | Open kitty |
| `Super+Q` | Close window |
| `Super+F` | File manager (kitty -e yazi) |
| `Super+E` | Jiffy launcher |
| `Super+W` | WallRizz wallpaper picker |
| `Super+N` | Toggle swaync notification center |
| `Super+T` | Toggle dwindle split |
| `Super+Shift+L` | Lock (hyprlock) |
| `Super+Shift+R` | Reload config |
| `Super+Shift+S` | Region screenshot → clipboard |
| `Print` | Full screenshot → `~/Pictures/` |
| `Super+H/L/K/J` | Focus left/right/up/down |
| `Super+[0-9]` | Switch workspace |
| `Super+Shift+[0-9]` | Move window to workspace |
| `Super+Mouse Scroll` | Cycle workspaces |
| `Super+LMB drag` | Move window |
| `Super+RMB drag` | Resize window |
| `XF86Audio*` | Volume / mic via wpctl |
| `XF86Brightness*` | Brightness via brightnessctl |
| `XF86Audio Next/Play/Pause/Prev` | Playerctl |

### Window rules
- Jiffy: float, 700×500, centered
- WallRizz: float, 900×600, centered
- Suppress app maximize requests globally

### Input
- Keyboard layout: Spanish (es); Capslock → Escape (keyd)
- Touchpad: natural scroll off; 3-finger horizontal swipe → workspace switch
- Epic mouse: −0.5 sensitivity

---

## Hyprlock

**Config:** `wayland/hypr/hyprlock.conf`

- Background: blurred current wallpaper (8px, 3 passes) + fallback `#1a1b26`
- No loading bar, hide cursor, no grace period
- Password field: 300×50px, blue border `#7aa2f7`, centered (−80px offset)
- Clock: 72pt bold, HH:MM, 1s refresh
- Date: 18pt, `Day, Month DD` format, 60s refresh

---

## Hypridle

**Config:** `wayland/hypr/hypridle.conf`

| Timeout | Action |
|---------|--------|
| 5 min | Dim to 20% brightness |
| 10 min | Lock session (loginctl) |
| 11 min | Turn off display |
| 30 min | Suspend system |

Before sleep → lock. After wake → display on.

---

## Waybar

**Config:** `wayland/waybar/` (modular jsonc + styles)

### Modules
| Module | Description |
|--------|-------------|
| `custom/user` (󰍜) | NixOS GTK menu: Edit config, Rebuild Switch/Test, Update Flake, Garbage Collect, Generations. Each action opens kitty, tees output to `/tmp/nix-<action>.log`, waits Enter to close |
| `custom/distro` (󱄅) | Opens kitty in `$HOME` with `NU_BANNER=1` → shows fastfetch + fortune greeting |
| Temperature | CPU temp, critical at 90°C |
| Memory | % usage, tooltip shows used/total GiB |
| CPU | % usage, updates 10s, warn 75%, critical 90% |
| Clock time | HH:MM, tooltip 12h AM/PM |
| Clock date | DD-MM + calendar popup on click |
| Network | WiFi signal bars, SSID/IP/freq tooltip; click → network menu; right-click → toggle WiFi |
| Bluetooth | Connected/battery % tooltip; click → bluetooth menu |
| Notifications | swaync integration, icon changes per state (normal/DND/inhibited) |
| Updates | Hourly package check; click → update TUI; right-click → refresh |
| Idle inhibitor | Toggle prevent screen sleep |
| MPRIS | Current track title - artist |
| PulseAudio output | Volume %, scroll ±5%, click mute; tooltip shows device |
| PulseAudio input | Mic level, muted state, scroll to change |
| Backlight | Brightness %, scroll to adjust |
| Battery | % + charge icon; notifications at 20% warn / 10% critical / 100% full |
| Power menu (󰍜) | Lock / Suspend / Hibernate / Reboot / Shutdown / Logout |

### Styling
Tokyo Night palette; buttons with 20px border-radius; layer top, dock mode.

---

## Swaync

**Config:** `wayland/swaync/`

- Position: top-right, 400px wide, 400×600 control center
- Animations: slide-right, 200ms open / 100ms close
- Timeouts: 5s default, 3s low, 0 (sticky) critical
- Widgets: title bar + clear-all, DND toggle, notifications list, MPRIS player (72px rounded art)
- Keyboard shortcuts enabled

---

## Jiffy

**Config:** `jiffy/launch.sh`

Application launcher — kitty-based, class `jiffy`, single instance, 90% opacity, Tokyo Night FZF colors.

---

## WallRizz

**Config:** `wallrizz/`

- Kitty window, class `wallrizz`, 90% opacity, lists `~/.config/wallpapers`
- `awww@daniel.js`: random transitions (fade/wipe/wave/grow/center/outer), 1s duration, 60fps, random position
- `color-backend.sh`: ImageMagick kmeans extraction of 16 hex colors per image for theme sync

---

## NixOS

**Config:** `nixos/configuration.nix`

### System
- Boot: systemd-boot, quiet, latest kernel, max 3 generations
- Audio: PipeWire + PulseAudio compat layer + ALSA 32-bit + RTKit
- Display: Hyprland enabled, X server + dconf + polkit
- Docker: rootless mode
- Printing: CUPS
- Network: NetworkManager, hostname `nixos`
- Locale: `en_US` / `es_ES` regional / Europe/Madrid timezone
- Shell: bash auto-launches nushell for interactive sessions
- Fonts: JetBrains Mono Nerd Font + Material Icons

### Notable user packages
Wayland: `hyprlock`, `hypridle`, `awww`, `waybar`, `swaync`, `hyprpicker`, `blueman`, `fastfetch`, `fortune`, `fzf`
Terminal: `kitty`, `starship`, `zoxide`, `yazi`, `bat`, `ripgrep`, `fd`, `delta`, `btop`, `dust`, `rm-improved`
Dev: `neovim`, `git`, `git-lfs`, `gcc`, `uv`, `nodejs`, `claude-code`
Apps: `brave`, `teams-for-linux`, `keepass`, `veracrypt`

### Custom packages
- `jiffy` v1.6.3 (auto-patch-elf)
- `wallrizz` v1.4.0 (auto-patch-elf)

---

## Useful aliases (nushell)

| Alias | Command |
|-------|---------|
| `nixos-re-sw` | `sudo nixos-rebuild switch` |
| `nixos-edit` | `sudo nvim /etc/nixos/configuration.nix` |
| `nixos-garbage` | `sudo nix-collect-garbage --delete-older-than 7d` |
| `n` | `nvim` |
| `z` | zoxide jump |
| `rm` | rip (trash, recoverable) |
| `rd` | restore from rip trash |
| `grep` | ripgrep |
| `find` | fd |
| `du` | dust |
| `top` | btop |
| `cb` | wl-copy |
| `cbp` | wl-paste |

---

## What NOT to do

- Don't edit files in `~/.config/` directly — they're symlinks, edits land in the repo automatically.
- Don't add helix back.
- Don't symlink `hardware-configuration.nix` on different hardware — regenerate with `nixos-generate-config` first.
- Don't remove `nofail` from the SHARED-PART mount — it must not block boot if missing.
- Don't set `NU_BANNER=1` in a normal kitty launch — it triggers fastfetch/fortune on every new shell in that window.
