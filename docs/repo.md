# Repo

Git LFS rules and the symlink map (`~/.config/*` → this repo).

## Git LFS
All raster images are LFS: `.gitattributes` has `*.jpg`, `*.jpeg`, `*.png`, `*.webp`. Hooks (`pre-push`, `post-checkout`, …) are installed per clone via `git lfs install`; a fresh clone needs `git lfs` available (it is in the system packages) or the images come out as 132-byte pointer files.
- **Check before committing a new image/binary type** — add its pattern to `.gitattributes` *first*. A pattern added afterwards does not touch what is already committed, and fixing it means rewriting history.
- Verify a file really went through LFS: `git lfs ls-files | grep <file>` (or `git cat-file -p HEAD:<file>` shows `version https://git-lfs.github.com/spec/v1`).
- 2026-11-16: history was rewritten with `git lfs migrate import --everything --include="*.png,*.jpeg"` and force-pushed, because PNG/JPEG wallpapers had gone in as plain blobs. All commit hashes changed; old clones must be re-cloned. `refs/pull/1/head` on GitHub still points at the pre-rewrite history.
- After a migrate/rewrite the working tree holds pointer files until `git lfs checkout` — run it, or wallpapers, hyprlock and the Brave icons break.
- SVGs are text and stay plain.
- `shell/nushell/history.txt` is gitignored and no longer tracked (it was committed once, in the repo-reorganisation commit, before the ignore rule; still present in old history, reviewed 2026-11-16: only `keepass`/`ssh-keygen` commands, no secrets).

## Symlink map

| Repo path | Symlinked to |
|-----------|-------------|
| `shell/nushell/` | `~/.config/nushell` |
| `dev/nvim/` | `~/.config/nvim` |
| `shell/starship/starship.toml` | `~/.config/starship.toml` |
| `apps/kitty/` | `~/.config/kitty` |
| `wm/wallpapers/` | `~/.config/wallpapers` |
| `shell/zoxide/config.nu` | `~/.config/zoxide/config.nu` |
| `apps/yazi/` | `~/.config/yazi` |
| `apps/wallrizz/` | `~/.config/WallRizz` |
| `apps/whosthere/` | `~/.config/whosthere` |
| `wm/wayland/hypr/` | `~/.config/hypr` |
| `wm/wayland/waybar/` | `~/.config/waybar` |
| `wm/wayland/swaync/` | `~/.config/swaync` |
| `wm/cursor/icons-default/index.theme` | `~/.icons/default/index.theme` |
| `wm/applications/rofi-filebrowser.desktop` | `~/.local/share/applications/rofi-filebrowser.desktop` |
| `apps/btop/` | `~/.config/btop` |
| `apps/fastfetch/` | `~/.config/fastfetch` |
| `apps/cava/` | `~/.config/cava` |
| `apps/rofi/` | `~/.config/rofi` |
| `dev/claude/settings.json` | `~/.claude/settings.json` |
| `shell/scripts/cava-vibe` | `~/.local/bin/cava-vibe` |
| `shell/scripts/vcvol` | `~/.local/bin/vcvol` |
| `system/nixos/configuration.nix` | `/etc/nixos/configuration.nix` (sudo) |

Run `./doller` to (re)create all symlinks. TUI shows status per link, backs up conflicts. `--dry-run` to preview, `--force` to skip prompt. `install.sh` is a shim that calls it.
