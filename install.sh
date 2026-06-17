#!/usr/bin/env bash
# install.sh — Symlinks dotfiles into ~/.config and /etc/nixos.
# Safe to re-run: backs up existing dirs, overwrites stale symlinks.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backs up any real (non-symlink) target before creating the symlink.
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "${dst}.bak"
        echo "backed up: ${dst} → ${dst}.bak"
    fi
    ln -sfn "$src" "$dst"
    echo "linked: $dst → $src"
}

# User config symlinks
link "$DOTFILES/nushell"                "$HOME/.config/nushell"
link "$DOTFILES/nvim"                   "$HOME/.config/nvim"
link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES/wayland/hypr"           "$HOME/.config/hypr"
link "$DOTFILES/kitty"                  "$HOME/.config/kitty"
link "$DOTFILES/wallpapers"             "$HOME/.config/wallpapers"
link "$DOTFILES/cursor"                 "$HOME/.config/cursors"

# NixOS system config — hardware-configuration.nix excluded (machine-specific, regenerate with nixos-generate-config)
if command -v nixos-rebuild &>/dev/null; then
    if sudo ln -sfn "$DOTFILES/nixos/configuration.nix" /etc/nixos/configuration.nix 2>/dev/null; then
        echo "linked: /etc/nixos/configuration.nix → $DOTFILES/nixos/configuration.nix"
    else
        echo "skipped: /etc/nixos/configuration.nix (needs sudo)"
    fi
fi

echo ""
echo "Done."
