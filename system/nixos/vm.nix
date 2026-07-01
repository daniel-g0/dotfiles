# vm.nix — Demo VM configuration (stripped for virt-manager distribution)
#
# Build a qcow2 image:
#   nix run github:nix-community/nixos-generators -- --format qcow2 --configuration ./nixos/vm.nix
#
# Import into virt-manager: New VM → Import existing disk image → select the .qcow2
# Login: user / nixos
# Dotfiles auto-install on first boot (needs internet).

{ config, pkgs, lib, ... }:

let
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
  imports = [];

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
  networking.hostName              = "dotfiles-demo";
  networking.networkmanager.enable = true;

  # -- Bluetooth -----------------------------------------------------------------
  hardware.bluetooth.enable      = true;
  hardware.bluetooth.powerOnBoot = true;

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
  hardware.uinput.enable = true;

  security.polkit.enable = true;
  programs.dconf.enable  = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.xserver.xkb = {
    layout  = "es";
    variant = "";
  };

  console.keyMap = "es";

  # -- QEMU guest agent ----------------------------------------------------------
  services.qemuGuest.enable = true;

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

  # -- Demo: passwordless sudo for wheel -----------------------------------------
  security.sudo.wheelNeedsPassword = false;

  # -- User ----------------------------------------------------------------------
  users.users."user" = {
    isNormalUser    = true;
    description     = "user";
    initialPassword = "nixos";
    extraGroups     = [ "networkmanager" "wheel" "video" "input" "uinput" ];
    packages        = with pkgs; [
      # Wayland / desktop
      swaynotificationcenter
      waybar
      hyprlock
      hypridle
      awww
      hyprpicker
      blueman
      bluez
      networkmanagerapplet
      libnotify
      fastfetch
      fortune
      lolcat
      timg
      imagemagick
      chafa
      rofi
      wallrizz
      brightnessctl
      layan-cursors
      papirus-icon-theme
      xdg-utils

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
      mapscii
      cava
      cmatrix
      sox
      whosthere

      # Wayland utilities
      wl-clipboard
      grim
      slurp
      wdisplays

      # Development
      neovim
      git
      git-lfs
      gcc
      uv
      nodejs
      claude-code
      lua-language-server

      # Apps
      brave
    ];
  };

  # -- System packages -----------------------------------------------------------
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nushell
    python3
    tokyonight-gtk-theme
  ];

  # -- Keyboard remapping --------------------------------------------------------
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
  programs.bash.interactiveShellInit = ''
    if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ]; then
      exec nu
    fi
  '';

  # -- Fonts ---------------------------------------------------------------------
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Tokyonight-Dark-BL
    gtk-icon-theme-name=Papirus-Dark
    gtk-font-name=JetBrainsMono Nerd Font 13
    gtk-application-prefer-dark-theme=1
  '';

  environment.etc."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Tokyonight-Dark-BL
    gtk-icon-theme-name=Papirus-Dark
    gtk-font-name=JetBrainsMono Nerd Font 13
    gtk-application-prefer-dark-theme=1
  '';

  environment.variables.GTK_THEME = "Tokyonight-Dark-BL";

  fonts = {
    enableDefaultPackages = true;
    packages              = with pkgs; [
      nerd-fonts.jetbrains-mono
      material-icons
    ];
  };

  system.activationScripts.usrbinbash = {
    text = ''
      mkdir -p /usr/bin
      ln -sfn /run/current-system/sw/bin/bash /usr/bin/bash
    '';
    deps = [];
  };

  system.activationScripts.usrshareapps = {
    text = ''
      mkdir -p /usr/share
      ln -sfn /run/current-system/sw/share/applications /usr/share/applications
    '';
    deps = [];
  };

  environment.etc."xdg/applications/yazi-kitty.desktop".text = ''
    [Desktop Entry]
    Name=Yazi File Manager
    Icon=yazi
    Comment=Yazi running inside kitty
    Terminal=false
    Exec=kitty -e yazi %f
    Type=Application
    MimeType=inode/directory;
    Categories=System;FileManager;
  '';

  environment.etc."xdg/mimeapps.list".text = ''
    [Default Applications]
    inode/directory=yazi-kitty.desktop
  '';

  # -- First-boot dotfiles setup -------------------------------------------------
  # Clones the dotfiles repo and runs ./doller --force on first boot.
  # Requires internet. Skips if ~/Projects/personal/dotfiles already exists.
  systemd.services.setup-dotfiles = {
    description = "Bootstrap dotfiles on first boot";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "network-online.target" "systemd-user-sessions.service" ];
    wants       = [ "network-online.target" ];
    serviceConfig = {
      Type            = "oneshot";
      User            = "user";
      Environment     = "HOME=/home/user";
      RemainAfterExit = true;
      ExecCondition   = "${pkgs.bash}/bin/bash -c 'test ! -d /home/user/Projects/personal/dotfiles'";
      ExecStart       = pkgs.writeShellScript "setup-dotfiles" ''
        set -e
        mkdir -p /home/user/Projects/personal
        cd /home/user/Projects/personal
        ${pkgs.git}/bin/git clone https://github.com/daniel-g0/dotfiles.git
        cd dotfiles
        ${pkgs.bash}/bin/bash ./doller --force
      '';
    };
  };

  # Required for standalone eval/build-vm; nixos-generators overrides this.
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  system.stateVersion = "26.05";
}
