#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

link "$DOTFILES/nushell"              "$HOME/.config/nushell"
link "$DOTFILES/nvim"                 "$HOME/.config/nvim"
link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES/wayland/hypr"         "$HOME/.config/hypr"
link "$DOTFILES/kitty"                "$HOME/.config/kitty"
link "$DOTFILES/wallpapers"           "$HOME/.config/wallpapers"

# NixOS — requires sudo (only configuration.nix; hardware-configuration.nix stays per-machine)
if command -v nixos-rebuild &>/dev/null; then
    if sudo ln -sfn "$DOTFILES/nixos/configuration.nix" /etc/nixos/configuration.nix 2>/dev/null; then
        echo "linked: /etc/nixos/configuration.nix → $DOTFILES/nixos/configuration.nix"
    else
        echo "skipped: /etc/nixos/configuration.nix (run with sudo or enter password when prompted)"
    fi
fi

echo ""
echo "Done."
