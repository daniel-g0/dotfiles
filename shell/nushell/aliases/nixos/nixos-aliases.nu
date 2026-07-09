# Edit configuration securely
export alias nixos-edit = nvim (^readlink -f /etc/nixos/configuration.nix)

export def nixos-re-sw [] {
    sudo nixos-rebuild switch -I nixos-config=/etc/nixos/configuration.nix
}

# Pull latest channel then rebuild
export def nixos-update [] {
    sudo nix-channel --update
    sudo nixos-rebuild switch -I nixos-config=/etc/nixos/configuration.nix
}

# Cleanup old generations to save space
export alias nixos-garbage = sudo nix-collect-garbage --delete-older-than 7d
