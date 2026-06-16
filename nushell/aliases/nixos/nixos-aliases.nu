# Edit configuration securely
export alias nixos-edit = sudo hx /etc/nixos/configuration.nix

# Cleanup old generations to save space
export alias nixos-garbage = sudo nix-collect-garbage --delete-older-than 7d
