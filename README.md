# dotfiles

Personal dotfiles for NixOS + Hyprland. Tokyo Night themed. Everything symlinked to `~/.config` via `install.sh`.

## Stack

| Tool | Purpose |
|------|---------|
| NixOS | OS |
| Hyprland | Wayland compositor |
| Nushell | Shell |
| Neovim | Editor (the only one) |
| Kitty | Terminal |
| Starship | Prompt |
| Waybar | Status bar |
| Hyprlock | Lock screen |
| Hypridle | Idle daemon |
| awww | Wallpaper |

## Install

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
bash install.sh
```

`install.sh` symlinks everything into `~/.config`. On NixOS it also links both nixos configs (requires sudo).

After install, rebuild NixOS to install all packages:

```bash
nixos-re-sw
```

## Structure

```
dotfiles/
├── nushell/            → ~/.config/nushell
├── nvim/               → ~/.config/nvim
├── starship/           → ~/.config/starship.toml
├── kitty/              → ~/.config/kitty
├── wallpapers/         → ~/.config/wallpapers
├── wayland/hypr/       → ~/.config/hypr
│   ├── hyprland.lua      compositor config
│   ├── hyprlock.conf     lock screen
│   └── hypridle.conf     idle/suspend timers
├── nixos/
│   ├── configuration.nix      → /etc/nixos/configuration.nix
│   └── hardware-configuration.nix → /etc/nixos/hardware-configuration.nix
└── install.sh
```

## Keybinds (Hyprland)

| Bind | Action |
|------|--------|
| `SUPER + HJKL` | Focus window (vim directions) |
| `SUPER + SHIFT + HJKL` | Move window |
| `SUPER + 1-9` | Switch workspace |
| `SUPER + RETURN` | Terminal (kitty) |
| `SUPER + Q` | Close window |
| `SUPER + F` | File manager (yazi) |
| `SUPER + E` | App launcher |
| `SUPER + SHIFT + L` | Lock screen |
| `SUPER + SHIFT + R` | Reload config |

## Idle / Lock timers

| Time | Action |
|------|--------|
| 5 min | Dim brightness |
| 10 min | Lock screen |
| 11 min | Screen off |
| 30 min | Suspend |

## Philosophy

Everything is vim-keybinding based. Nushell in vi mode. Hyprland navigated with hjkl. Neovim obviously. Even the shell prompt indicators are `ι` (insert) and `η` (normal) because regular people use arrow keys and real men use hjkl.

If you need a mouse to use this setup, you're in the wrong repo.
