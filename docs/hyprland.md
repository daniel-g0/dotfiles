# Hyprland

Compositor config, keybindings, input, plus hyprlock and hypridle. Known bugs live in [known-issues.md](known-issues.md).

## Hyprland

**Config:** `wayland/hypr/hyprland.lua` (Lua-based)

### Autostart
`waybar`, `swaync`, `hypridle`, `awww-daemon` (wallpaper: `Nix Tokyo Night.png`, 2s fade), `hyprctl setcursor Layan-cursors 24`

### Appearance
- Gaps: in 5px / out 20px; border 3px; rounding 10px
- Active border: liquid gradient blue→purple→cyan (animated, angle loops)
- Inactive border: animated gradient — same hues as active at 33% opacity (`rgba(...55)`)
- Shadow: `#7aa2f7` 22% / inactive `#1a1b26` 12%
- Blur: 16px, 6 passes, vibrancy 0.3

### Display configuration
**Tool:** `wdisplays` GUI for display layout (Super+M)  
Configure monitor arrangement, resolution, refresh rate graphically.

Work desk, left → right, all scale 1.33 (1440 px logical steps): **Dell U2417H** `0x0` · **Dell U2419H** `1440x0` · **eDP-1** (laptop) `2880x0`.
- **Externals are matched by `desc:` (model + serial), not connector name.** The dock renumbers its MST outputs on every re-dock (DP-3/DP-4 → DP-5/DP-6 on 2026-11-18). Name rules then match nothing: scale falls back to 1 and the externals land right of the laptop. Descriptions: `hyprctl monitors` (or `drm: Description … (DP-n)` in the Hyprland log).
- Apply a rule live without reload: `hyprctl eval 'hl.monitor({ output = "desc:…", position = "0x0", scale = "1.33" })'`.

### Keybindings (Super key)
| Binding | Action |
|---------|--------|
| `Super+Return` | Open kitty |
| `Super+Q` | Close window |
| `Super+F` | File manager (kitty -e yazi) |
| `Super+E` | Rofi app launcher |
| `Super+M` | Display configuration (wdisplays) |
| `Super+W` | WallRizz wallpaper picker |
| `Super+N` | Toggle swaync notification center |
| `Super+C` | Keybindings cheatsheet (fzf browser) |
| `Super+T` | Toggle dwindle split |
| `Super+Shift+L` | Lock (hyprlock) |
| `Super+Shift+W` | LAN discovery (whosthere) |
| `Super+R` | Reload config |
| `Super+Shift+S` | Region screenshot → clipboard |
| `Print` | Full screenshot → `~/Pictures/` |
| `Super+H/L/K/J` | Focus left/right/up/down |
| `Super+[1-9,0]` | Switch workspace (`0` = workspace 10; 10 per monitor via split-monitor-workspaces) |
| `Super+Shift+[1-9,0]` | Move window to workspace |
| `Super+Mouse Scroll` | Cycle workspaces |
| `Super+LMB drag` | Move window |
| `Super+RMB drag` | Resize window |
| `XF86Audio*` | Volume / mic via wpctl |
| `XF86Brightness*` | Brightness via brightnessctl |
| `XF86Audio Next/Play/Pause/Prev` | Playerctl |

### Window rules
- WallRizz: float, 900×600, centered
- Suppress app maximize requests globally

### Input
- Keyboard layout: Spanish (es); Capslock → Escape (keyd)
- Touchpad: natural scroll off; 3-finger horizontal swipe → workspace switch
- Epic mouse: −0.5 sensitivity (device `epic-mouse-v1` is the upstream example name, matches nothing here)
- keyd `ids = [ "*" ]` (`system/nixos/configuration.nix`) also grabs the **Logitech Wireless Mouse** `046d:4054` (it reports keys too) and re-emits it via `keyd virtual pointer`. Harmless so far; to exclude it: `ids = [ "*" "-046d:4054" ]`. keyd ignores the touchpad.

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
