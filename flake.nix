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
      modules = [
        { nixpkgs.hostPlatform = "x86_64-linux"; }
        /etc/nixos/hardware-configuration.nix
        ./system/nixos/configuration.nix
        qylock.nixosModules.default
        {
          programs.qylock = {
            enable      = true;
            theme       = "pixel-night-city";
            sddm.enable = true;
          };

          services.displayManager.sddm.enable         = true;
          services.displayManager.sddm.wayland.enable = true;
        }
      ];
    };
  };
}
