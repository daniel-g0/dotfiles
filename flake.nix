{
  description = "NixOS dotfiles — Tokyo Night";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    qylock = {
      url    = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, qylock, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        qylock.nixosModules.default
        {
          programs.qylock = {
            enable      = true;
            theme       = "pixel-night-city";
            sddm.enable = true;
          };

          services.displayManager.sddm.wayland.enable = true;
        }
      ];
    };
  };
}
