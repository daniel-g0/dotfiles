# Edit configuration securely
export alias nixos-edit = sudo nvim /etc/nixos/configuration.nix
export alias nixos-re-sw = sudo nixos-rebuild switch

# Cleanup old generations to save space
export alias nixos-garbage = sudo nix-collect-garbage --delete-older-than 7d
