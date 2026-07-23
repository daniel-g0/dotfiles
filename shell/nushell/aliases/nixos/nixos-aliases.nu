# Edit configuration securely
export alias nixos-edit = nvim (^readlink -f /etc/nixos/configuration.nix)

export def nixos-re-sw [] {
    sudo nixos-rebuild switch --flake /home/user/Projects/personal/dotfiles#nixos --impure
}

# Pull latest channel then rebuild
export def nixos-update [] {
    sudo nix-channel --update
    sudo nixos-rebuild switch --flake /home/user/Projects/personal/dotfiles#nixos --impure
}

# Cleanup old generations to save space
export alias nixos-garbage = sudo nix-collect-garbage --delete-older-than 7d
