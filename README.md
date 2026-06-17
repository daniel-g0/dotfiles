# dotfiles

Personal dotfiles for NixOS + Hyprland. Everything symlinked to `~/.config` via `install.sh`.

## Stack

| Tool | Purpose |
|------|---------|
| NixOS | OS |
| Hyprland | Wayland compositor |
| Nushell | Shell |
| Neovim | Editor (the only one) |
| Starship | Prompt |
| Kitty | Terminal |

## Install

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
bash install.sh
```

`install.sh` symlinks everything into `~/.config`. On NixOS it also links `configuration.nix` into `/etc/nixos` (requires sudo, hardware-configuration.nix stays per-machine).

## Structure

```
dotfiles/
├── nushell/          → ~/.config/nushell
├── nvim/             → ~/.config/nvim
├── starship/         → ~/.config/starship.toml
├── wayland/hypr/     → ~/.config/hypr
├── nixos/            → /etc/nixos/configuration.nix (sudo)
├── kitty/            → ~/.config/kitty
└── install.sh        # run this
```

## Philosophy

Everything is vim-keybinding based. Nushell in vi mode. Hyprland navigated with hjkl. Neovim obviously. Even the shell prompt indicators are `ι` (insert) and `η` (normal) because regular people use arrow keys and real men use hjkl.

If you need a mouse to use this setup, you're in the wrong repo.
