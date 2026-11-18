# CLAUDE.md

## TODO (urgent)

- **Teams screen share unverified** — switched Hyprland to UWSM (`configuration.nix`) to get `graphical-session.target` → `xdg-desktop-portal` up. Needs `nixos-re-sw`, re-login, then the `systemctl --user is-active …` check and a share test in Teams (see "System" in [docs/nixos.md](docs/nixos.md)).

- **Mouse-click freeze: mitigation undecided** — clicks died session-wide on 2026-11-18; suspected Hyprland 0.56.2 `window.resize()` bug (see "Mouse clicks dead" in [docs/known-issues.md](docs/known-issues.md)). Pick one: drop the `Super+RMB` resize bind for `resize_on_border`, or overlay upstream fix `1c4fbb6`. Or wait for a release that has it.

- **Waybar layout unverified** — clock-in-centre + 6/6 icon split was done without a screenshot. Check the expanded bar: gaps equal? clock centred? If not, measure the real clock height and adjust `CLOCK_H` in `scripts/toggle-layout`.

## Repo

Personal dotfiles. Files in this repo are the source of truth — `~/.config/*` are symlinks pointing here. Theme: Tokyo Night across all tools.

## Docs (read on demand)

Details live in `docs/`. Read the file for the area you're touching before changing it.

| File | Covers |
|------|--------|
| [docs/repo.md](docs/repo.md) | Git LFS rules, symlink map, `./doller` |
| [docs/theming.md](docs/theming.md) | `apply-theme` palette + presets, per-app gotchas, WallRizz, animated-wallpaper research |
| [docs/shell.md](docs/shell.md) | Nushell (hooks, FZF, alias modules, completions), Starship, alias table |
| [docs/kitty.md](docs/kitty.md) | Kitty config, remote-control sockets, custom tab bar |
| [docs/hyprland.md](docs/hyprland.md) | Hyprland (autostart, look, **keybindings**, rules, input, keyd), Hyprlock, Hypridle |
| [docs/waybar.md](docs/waybar.md) | Waybar modules + styling, Swaync |
| [docs/nixos.md](docs/nixos.md) | NixOS system, packages, certs, UWSM, uv-managed tools |
| [docs/known-issues.md](docs/known-issues.md) | Investigated bugs: mouse clicks dead (Hyprland 0.56.2), waybar CPU/thermals |

---

## What NOT to do

- Don't edit files in `~/.config/` directly — they're symlinks, edits land in the repo automatically.
- Don't add helix back.
- Don't symlink `hardware-configuration.nix` on different hardware — regenerate with `nixos-generate-config` first.
- Don't put certs in the repo — they live at `~/.config/certs/`, outside version control.
- Don't remove `nofail` from the SHARED-PART mount — it must not block boot if missing.
- Don't set `NU_BANNER=1` in a normal kitty launch — it triggers fastfetch/fortune on every new shell in that window.
- Don't add styles to `wayland/waybar/styles/modules-*.css` — those files are **not imported** anywhere and have zero effect. All waybar CSS goes in `wayland/waybar/style.css`.
- Don't re-enable the waybar `border-flow` animation (or an animated `box-shadow`) — GTK3 repaints the bar on the CPU every frame (~60 % of a core, 94 °C). See "Waybar CPU / thermals" in [docs/known-issues.md](docs/known-issues.md).
- Don't use legacy `hyprctl dispatch <name> <args>` syntax — Hyprland 0.56 Lua config needs `hyprctl dispatch 'hl.dsp.…()'`.
- Don't "fix" the mouse binds because `hyprctl binds -j` reports `"mouse": false` — expected with the Lua config. See "Mouse clicks dead" in [docs/known-issues.md](docs/known-issues.md).
- Don't symlink cursor dirs to `~/.config/cursors` expecting X fallback — standard path is `~/.icons/`. `~/.icons/default/index.theme` controls the X11 default cursor (was `Inherits=NixCursor`, fixed to `Inherits=Layan-cursors`).
