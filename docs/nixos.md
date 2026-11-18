# NixOS

System config, packages, certs, and tools installed outside Nix.

## NixOS

**Config:** `nixos/configuration.nix`

### System
- Boot: systemd-boot, quiet, latest kernel, max 3 generations
- Audio: PipeWire + PulseAudio compat layer + ALSA 32-bit + RTKit
- Display: Hyprland enabled, X server + dconf + polkit
- **Hyprland via UWSM** (`programs.hyprland.withUWSM = true`, SDDM autologin `defaultSession = "hyprland-uwsm"`). Raw Hyprland left `graphical-session.target` inactive, so `xdg-desktop-portal.service` failed with `Dependency failed for Portal service.` and Teams screen share (ScreenCast via PipeWire) never got a portal/picker. Changed 2026-11-16 — **not yet rebuilt/verified** (see TODO). Check: `systemctl --user is-active graphical-session.target xdg-desktop-portal` → both `active`. If login breaks, boot the previous generation and revert those two lines.
- Docker: rootless mode
- Printing: CUPS
- Network: NetworkManager, hostname `nixos`
- Locale: `en_US.UTF-8` everywhere (no `es_ES` regional overrides) / Europe/Madrid timezone / Spanish (es) keyboard layout
- Shell: bash auto-launches nushell for interactive sessions
- Fonts: JetBrains Mono Nerd Font + Material Icons

### Notable user packages
Wayland: `hyprlock`, `hypridle`, `awww`, `waybar`, `swaync`, `hyprpicker`, `blueman`, `fastfetch`, `fortune`, `fzf`
Terminal: `kitty`, `starship`, `zoxide`, `yazi`, `bat`, `ripgrep`, `fd`, `delta`, `btop`, `dust`, `rm-improved`, `mapscii`
Dev: `neovim`, `git`, `git-lfs`, `gcc`, `uv`, `nodejs`, `claude-code`
Apps: `brave`, `teams-for-linux`, `keepass`, `veracrypt`

### Custom packages
- `wallrizz` v1.4.0 (auto-patch-elf)

### Private certificates
Certs live at `~/.config/certs/*.crt` — outside the repo, untracked. `configuration.nix` loads them automatically via `SUDO_USER` at rebuild time. If the directory is absent, no certs are added (graceful). To add a cert: drop a `.crt` file in `~/.config/certs/` and run `nixos-re-sw`.

---

## Non-Nix tools (uv-managed)

Some tools aren't in nixpkgs. These are installed via `uv tool install` (uv is in system packages) and live in `~/.local/share/uv/tools/`. Binaries exposed at `~/.local/bin/`.

| Tool | Install | Purpose | Status |
|------|---------|---------|--------|
| `claude-swap` (`cswap`) | `uv tool install claude-swap` | Multi-account Claude Code manager — switch accounts, track quota, auto-switch before rate limits | ⏳ pending nixpkgs / custom derivation |

To reinstall after a fresh system: `uv tool install claude-swap && echo "Y" \| cswap list` (registers current Claude account).
To upgrade: `cswap upgrade` or `uv tool upgrade claude-swap`.

> **TODO:** Package these as proper Nix derivations once in nixpkgs, or write `buildPythonApplication` derivations. Track at: https://github.com/NixOS/nixpkgs/issues (search "claude-swap").
