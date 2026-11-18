# Waybar & Swaync

Bar modules, styling, and the notification daemon. Thermal investigation: [known-issues.md](known-issues.md).

## Waybar

**Config:** `wayland/waybar/` (modular jsonc + styles)

### Modules
| Module | Description |
|--------|-------------|
| `custom/user` (󱄅) | NixOS GTK menu (NixOS logo icon): Edit config, Rebuild Switch/Test, Update Flake, Garbage Collect, Generations, Rice (opens fastfetch+fortune kitty). Each action opens kitty, tees output to `/tmp/nix-<action>.log`, waits Enter to close |
| `custom/eyecare` (󰛐) | 20-20-20 eye break timer. Lives in `group/time` pill with clock. Fires swaync notification every 20min, auto-resets. Click to reset early. State file: `~/.local/state/eyecare-start`. Script: `wayland/waybar/scripts/eyecare` |
| Temperature | CPU temp, critical at 90°C |
| Memory | % usage, tooltip shows used/total GiB |
| CPU | % usage, updates 10s, warn 75%, critical 90% |
| `clock` (center) | HH over MM as text, **alone in `modules-center`** so it sits at the true vertical centre of the bar. Click toggles minimal/full (`scripts/toggle-layout`); hover shows full date + calendar tooltip. Layout top→bottom, all four gaps equal: nix + 6 system icons (`group/left`: temp, mem, cpu, disk, brightness, battery) · clock · 6 connectivity/audio icons (`group/right`: bluetooth, out, in, network, vpn, bell) + power. Both sides have 7 slots, and all four gaps are equal. Top stack hangs from the top, bottom one from the bottom; gaps beside the clock are the free space between the boxes, the ones under nix / above power are margins on `#custom-user` / `#custom-power`, computed by `launch`/`toggle-layout` from the monitor's logical height into `$XDG_RUNTIME_DIR/waybar-layout.css` (imported last by `style.css`; plain absolute path, `url("file://…")` silently fails). Every icon has a fixed ~34–35px slot (`2×padding + 1.335×font-size`, see "Icon slots" in `style.css`); `toggle-layout` hardcodes the stack heights (top 244.4, bottom 242.9, clock 42.7 — the clock height is an estimate, measure it); changing an icon's font-size or padding means re-deriving its slot. The old `custom/desktop` number module was removed (script `scripts/desktop` is now unused). A visible `mpris` adds one top slot and unbalances the gaps while it shows. The salary ticker (`custom/ganancias`) was removed |
| Clock date | DD-MM + calendar popup on click |
| Network | WiFi signal bars, SSID/IP/freq tooltip; click → network menu; right-click → toggle WiFi |
| `custom/vpn` (󰦝) | vpnc VPN manager. Green=connected (IP tooltip), red=disconnected. Click → VPNC TUI fzf menu: connect/disconnect/import/edit configs. Configs at `~/.config/vpns/` (untracked) |
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

- **Bar edges line up with the windows:** the bar's top/bottom margin is Hyprland's `general:gaps_out` (20), read by `launch` and written into the temp config (`config.jsonc` has the same default). Verified with `hyprctl layers` / `hyprctl clients`: bar y=20…1060, windows 20…1060 (incl. 3px border). If you change `gaps_out`, restart the bar.
- **Restart it with `pkill waybar` (not `-x`)** — the real process name is `.waybar-wrapped`, so `pkill -x waybar` matches nothing and a second bar stacks next to the first one (they showed up as two `waybar` layers in `hyprctl layers`). Always check there is one: `pgrep -af '^waybar --config'`.

---

## Swaync

**Config:** `wayland/swaync/`

- Position: top-right, 400px wide, 400×600 control center
- Animations: slide-right, 200ms open / 100ms close
- Timeouts: 5s default, 3s low, 0 (sticky) critical
- Widgets: title bar + clear-all, DND toggle, notifications list, MPRIS player (72px rounded art)
- Keyboard shortcuts enabled
