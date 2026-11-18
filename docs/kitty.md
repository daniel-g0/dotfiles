# Kitty

Terminal config and the custom tab bar.

## Kitty

**Config:** `kitty/kitty.conf` | **Tab bar:** `kitty/tab_bar.py`

- Font: JetBrainsMono Nerd Font 12pt
- Tokyo Night colors, 75% opacity, frosted blur (via Hyprland window rule)
- Scrollback: 10,000 lines; padding 8px; block cursor, no blink
- Repaint 10ms, input delay 3ms, sync to monitor
- Remote control via per-instance Unix sockets `/tmp/kitty-<pid>` (kitty appends the PID to `listen_on`, so `/tmp/kitty` itself never exists — `apply-theme` globs `/tmp/kitty-*` to recolor every running window)

### Custom tab bar (`tab_bar.py`)
Parses nushell pre-prompt title (`~/path 󰊢 branch [+1 ~2] | 5f 2d | 14:23`):
- **Single tab:** Title centered full-width
- **Multi-tab:** Segments — directory (blue), branch (purple), file counts (cyan), time (green)
- Bar sits at the **top** (`tab_bar_edge top`). Title text is underlined, not on a different background. It must be exactly as translucent as the body, which took measuring screenshots: cells `tab_bar.py` draws with the default bg render darker than the body (sharp step), and fully transparent cells (`@0`) show clear glass. So the bar is filled with the palette bg **+1 blue** (visually identical, but not "the default bg"), listed in `transparent_background_colors` at the **same opacity as `background_opacity`** (read from `kitty.conf` by `kitty_bar_alpha()` in apply-theme; written to `dynamic-colors.conf`, colour derived identically in `tab_bar.py` `_bar_fill`). Measured, that gives step 0. Any remaining difference is wallpaper showing through the blur, not kitty.
- Segment colors come from the active palette (`~/.cache/dynamic-theme/palette.json`): blue, accent, cyan, green
