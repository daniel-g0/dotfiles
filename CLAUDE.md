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
| `wayland/hypr/` | `~/.config/hypr` |
| `nixos/configuration.nix` | `/etc/nixos/configuration.nix` (sudo) |
| `nixos/hardware-configuration.nix` | `/etc/nixos/hardware-configuration.nix` (sudo) |

Run `bash install.sh` to (re)create all symlinks. Safe to re-run.

## Key conventions

- Editor everywhere: `nvim`. `$EDITOR` and `$VISUAL` set in nushell. No helix, no nano.
- Shell: Nushell in vi mode. Aliases in `nushell/aliases/<tool>/<tool>-aliases.nu`.
- NixOS: edit `nixos/configuration.nix`, then `nixos-re-sw` (alias → `sudo nixos-rebuild switch`).
- Hyprland config is Lua-based (`wayland/hypr/hyprland.lua`).
- Lock screen config: `wayland/hypr/hyprlock.conf`. Idle timers: `wayland/hypr/hypridle.conf`.
- Wallpaper set via `awww` on Hyprland start. Files in `wallpapers/`.
- Kitty: Tokyo Night colors + 75% opacity + frosted blur (via Hyprland).
- NvChad base with `tokyodark` theme set in `nvim/lua/chadrc.lua`.

## Useful aliases (nushell)

| Alias | Command |
|-------|---------|
| `nixos-re-sw` | `sudo nixos-rebuild switch` |
| `nixos-edit` | `sudo nvim /etc/nixos/configuration.nix` |
| `n` | `nvim` |

## What NOT to do

- Don't edit files in `~/.config/` directly — they're symlinks, edits land in the repo automatically.
- Don't add helix back.
- Don't symlink hardware-configuration.nix on different hardware — regenerate with `nixos-generate-config` first.
- Don't remove `nofail` from the SHARED-PART mount — it must not block boot if missing.
