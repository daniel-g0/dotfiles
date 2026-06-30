# Edit configuration securely
export alias nixos-edit = nvim (^readlink -f /etc/nixos/configuration.nix)
export def nixos-re-sw [] {
    let flake = (^readlink -f /etc/nixos/configuration.nix | path dirname | path dirname)
    sudo nixos-rebuild switch --flake $"($flake)#nixos" --impure
}

# Cleanup old generations to save space
export alias nixos-garbage = sudo nix-collect-garbage --delete-older-than 7d
