# CLAUDE.md

## Repo

Personal dotfiles. Files in this repo are the source of truth — `~/.config/*` are symlinks pointing here.

## Symlink map

| Repo path | Symlinked to |
|-----------|-------------|
| `nushell/` | `~/.config/nushell` |
| `nvim/` | `~/.config/nvim` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `wayland/hypr/` | `~/.config/hypr` |
| `nixos/configuration.nix` | `/etc/nixos/configuration.nix` (sudo) |

Run `bash install.sh` to (re)create all symlinks. Safe to re-run.

## Key conventions

- Editor everywhere: `nvim`. No helix, no nano, no vim.
- Shell: Nushell in vi mode. Aliases live in `nushell/aliases/<tool>/<tool>-aliases.nu`.
- NixOS: edit `nixos/configuration.nix`, then `nixos-re-sw` (alias for `sudo nixos-rebuild switch`).
- `hardware-configuration.nix` is NOT tracked — machine-specific, regenerate with `nixos-generate-config`.
- Hyprland config is Lua-based (`wayland/hypr/hyprland.lua`).

## What NOT to do

- Don't edit files in `~/.config/` directly — they're symlinks, edits land in the repo automatically, but create files in the repo path to keep things clear.
- Don't symlink `hardware-configuration.nix` — will break other machines.
- Don't add helix back.
