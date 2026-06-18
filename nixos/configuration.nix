# configuration.nix — NixOS system configuration.
# Edit here, then apply: nixos-re-sw (alias for: sudo nixos-rebuild switch)

{ config, pkgs, lib, ... }:

let
  jiffy = pkgs.stdenv.mkDerivation {
    pname = "jiffy";
    version = "1.6.3";
    src = pkgs.fetchurl {
      url = "https://github.com/5hubham5ingh/jiffy/releases/download/v1.6.3/jiffy-linux-86_64.tar.gz";
      hash = "sha256-6JJyVe+wjLNzPf5WINv5Zt4GuOrUsVUPhWYtBfdVYOA=";
    };
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];
    unpackPhase = "tar -xzf $src";
    installPhase = ''
      mkdir -p $out/bin
      install -m755 jiffy $out/bin/jiffy
    '';
  };

  wallrizz = pkgs.stdenv.mkDerivation {
    pname = "wallrizz";
    version = "1.4.0";
    src = pkgs.fetchurl {
      url = "https://github.com/5hubham5ingh/WallRizz/releases/download/v1.4.0/WallRizz-linux-86_64.tar.gz";
      hash = "sha256-qBwd6yN8m1YKCVCma81UZFxQ2//ymk/ZRFNHigAnKBk=";
    };
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];
    unpackPhase = "tar -xzf $src";
    installPhase = ''
      mkdir -p $out/bin
      install -m755 WallRizz $out/bin/WallRizz
    '';
  };
in

{
  imports = [
    ./hardware-configuration.nix
  ];

  # -- Nix settings --------------------------------------------------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # -- Boot ----------------------------------------------------------------------
  boot.loader.systemd-boot.enable             = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables        = true;
  boot.kernelPackages                         = pkgs.linuxPackages_latest;
  boot.kernelParams                           = [ "quiet" ];
  boot.initrd.verbose                         = false;

  # -- Networking ----------------------------------------------------------------
  networking.hostName              = "nixos";
  networking.networkmanager.enable = true;
  networking.wireless.enable       = true;

  # -- Locale & timezone ---------------------------------------------------------
  time.timeZone      = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT    = "es_ES.UTF-8";
    LC_MONETARY       = "es_ES.UTF-8";
    LC_NAME           = "es_ES.UTF-8";
    LC_NUMERIC        = "es_ES.UTF-8";
    LC_PAPER          = "es_ES.UTF-8";
    LC_TELEPHONE      = "es_ES.UTF-8";
    LC_TIME           = "es_ES.UTF-8";
  };

  # -- Display & desktop ---------------------------------------------------------
  services.xserver.enable = true;
  programs.hyprland = {
    enable   = true;
    withUWSM = false;
  };

  security.polkit.enable = true;
  programs.dconf.enable  = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";  # hint electron apps to use wayland

  services.xserver.xkb = {
    layout  = "es";
    variant = "";
  };

  console.keyMap = "es";

  # -- Printing ------------------------------------------------------------------
  services.printing.enable = true;

  # -- Audio (pipewire) ----------------------------------------------------------
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };

  # -- User ----------------------------------------------------------------------
  users.users."user" = {
    isNormalUser = true;
    description  = "user";
    extraGroups  = [ "networkmanager" "wheel" "video" ];
    packages     = with pkgs; [
      # Wayland / desktop
      swaynotificationcenter
      waybar
      hyprlock
      hypridle
      awww
      hyprpicker
      blueman
      bluez
      libnotify
      fastfetch
      fortune
      lolcat
      fzf
      timg
      jiffy
      wallrizz
      brightnessctl

      # Terminal & shell tools
      kitty
      starship
      rm-improved
      zoxide
      yazi
      fzf
      bat
      tldr
      tree
      file
      dos2unix
      jq
      wget
      ripgrep
      fd
      delta
      btop
      dust

      # Wayland utilities
      wl-clipboard
      grim
      slurp

      # Development
      neovim
      git
      git-lfs
      gcc
      uv
      nodejs
      claude-code

      # Apps
      brave
      teams-for-linux
      keepass
      veracrypt
      chezmoi
    ];
  };

  # -- System packages -----------------------------------------------------------
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nushell
    veracrypt
    python3
  ];

  # -- Docker (rootless) ---------------------------------------------------------
  virtualisation.docker.enable                     = true;
  virtualisation.docker.rootless.enable            = true;
  virtualisation.docker.rootless.setSocketVariable = true;

  # -- Keyboard remapping --------------------------------------------------------
  # Remap capslock → escape system-wide via keyd daemon.
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids      = [ "*" ];
        settings = {
          main = {
            capslock = "esc";
          };
        };
      };
    };
  };

  # -- Shell: auto-launch nushell from bash --------------------------------------
  # When bash starts interactively (not a script, not a dumb terminal), exec nu.
  programs.bash.interactiveShellInit = ''
    if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ]; then
      exec nu
    fi
  '';

  # -- Fonts ---------------------------------------------------------------------
  fonts = {
    enableDefaultPackages = true;
    packages              = with pkgs; [
      nerd-fonts.jetbrains-mono
      material-icons
    ];
  };

  # This value pins the NixOS release for stateful data defaults.
  # Change only when intentionally migrating state. See: man configuration.nix
  system.stateVersion = "26.05";
}
