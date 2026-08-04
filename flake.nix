{
  description = "NixOS dotfiles — Tokyo Night";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        { nixpkgs.hostPlatform = "x86_64-linux"; }
        /etc/nixos/hardware-configuration.nix
        ./system/nixos/configuration.nix
      ];
    };
  };
}
