# Edit configuration securely
export alias nixos-edit = nvim (^readlink -f /etc/nixos/configuration.nix)

export def nixos-re-sw [] {
    let conf_dir = (^readlink -f /etc/nixos/configuration.nix | path dirname | str trim)
    let dotfiles = (^git -C $conf_dir rev-parse --show-toplevel | str trim)
    sudo nixos-rebuild switch --flake $"($dotfiles)#nixos" --impure
}

# Pull latest channel then rebuild
export def nixos-update [] {
    sudo nix-channel --update
    let conf_dir = (^readlink -f /etc/nixos/configuration.nix | path dirname | str trim)
    let dotfiles = (^git -C $conf_dir rev-parse --show-toplevel | str trim)
    sudo nixos-rebuild switch --flake $"($dotfiles)#nixos" --impure
}

# Cleanup old generations to save space
export alias nixos-garbage = sudo nix-collect-garbage --delete-older-than 7d
