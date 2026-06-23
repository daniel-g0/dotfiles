<div align="center">

# ❄️ dotfiles

**NixOS · Hyprland · Tokyo Night — end-to-end**

[![NixOS](https://img.shields.io/badge/NixOS-flakes-5277C3?style=flat-square&logo=nixos&logoColor=white)](https://nixos.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-Lua-58E1FF?style=flat-square)](https://hyprland.org)
[![Tokyo Night](https://img.shields.io/badge/theme-Tokyo%20Night-7aa2f7?style=flat-square)](https://github.com/enkia/tokyo-night-vscode-theme)
[![License](https://img.shields.io/badge/license-MIT-bb9af7?style=flat-square)](LICENSE)

[![Stars](https://img.shields.io/github/stars/daniel-g0/dotfiles?style=flat-square&color=9ece6a&logo=github&label=stars)](https://github.com/daniel-g0/dotfiles/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/daniel-g0/dotfiles?style=flat-square&color=f7768e)](https://github.com/daniel-g0/dotfiles/commits/main)
[![Repo size](https://img.shields.io/github/repo-size/daniel-g0/dotfiles?style=flat-square&color=7dcfff)](https://github.com/daniel-g0/dotfiles)

![Desktop](screenshots/desktop.png)

</div>

---

## Stack

| | Tool | Role |
|-|------|------|
| OS | **NixOS** (flakes) | Declarative, reproducible |
| WM | **Hyprland** | Lua config, animated borders |
| Shell | **Nushell** | Vi mode, SQLite history |
| Editor | **Neovim** | NvChad |
| Terminal | **Kitty** | Custom Python tab bar |
| Bar | **Waybar** | Modular jsonc + CSS |
| Notifications | **swaync** | Slide-right panel |
| Wallpapers | **awww** + **WallRizz** | Daemon + fuzzy picker |
| Launcher | **Jiffy** | fzf in kitty |
| Prompt | **Starship** | Single-line, icons only |

---

## Install

```bash
git clone https://github.com/daniel-g0/dotfiles ~/dotfiles
cd ~/dotfiles && ./doller
sudo nixos-rebuild switch
```

`doller` — TUI symlink installer. `--dry-run` to preview, `--force` to skip prompt.

---

## Symlinks

| Repo | → | Target |
|------|---|--------|
| `nushell/` | | `~/.config/nushell` |
| `nvim/` | | `~/.config/nvim` |
| `kitty/` | | `~/.config/kitty` |
| `starship/starship.toml` | | `~/.config/starship.toml` |
| `yazi/` | | `~/.config/yazi` |
| `wallpapers/` | | `~/.config/wallpapers` |
| `wallrizz/` | | `~/.config/wallrizz` |
| `wayland/hypr/` | | `~/.config/hypr` |
| `wayland/waybar/` | | `~/.config/waybar` |
| `wayland/swaync/` | | `~/.config/swaync` |
| `nixos/configuration.nix` | | `/etc/nixos/configuration.nix` |

> Never edit `~/.config/*` directly — they're symlinks. Edits land in the repo.

---

## Highlights

**Hyprland** — Lua API, animated gradient border (blue→purple→cyan), 75% opacity kitty, frosted blur.

![Rice](screenshots/rice.png)

**Waybar** — NixOS menu · CPU/RAM/Temp · Clock · Network · VPN (󰦝 vpnc TUI) · Bluetooth · Volume · Battery · Power.

**VPN** — `custom/vpn` waybar module. Click → fzf TUI: connect/disconnect/import `.pcf`. Configs at `~/.config/vpns/` (untracked).

**Nushell** — Vi mode, 100k SQLite history, zoxide, FZF (`Ctrl+R/T`, `Alt+C`), 150+ git aliases, 35+ docker aliases.

**NixOS certs** — Drop `.crt` in `~/.config/certs/`, run `nixos-re-sw`. Auto-installed system-wide, never tracked.

**WallRizz** — `Super+W`. fzf picker + awww transitions + live Tokyo Night color sync to kitty/Hyprland borders.

---

## Key aliases

| Alias | Does |
|-------|------|
| `nixos-re-sw` | `sudo nixos-rebuild switch` |
| `n` | nvim |
| `z` | zoxide jump |
| `rm` | rip (trash, recoverable) |
| `grep` / `find` / `du` / `top` | rg / fd / dust / btop |
| `cb` / `cbp` | wl-copy / wl-paste |
