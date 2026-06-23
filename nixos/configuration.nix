# configuration.nix — NixOS system configuration.
# Edit here, then apply: nixos-re-sw (alias for: sudo nixos-rebuild switch)

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

  # Detected at eval time — builds on same machine so this is correct.
  iommuParam =
    if lib.hasInfix "AuthenticAMD" (builtins.readFile "/proc/cpuinfo")
    then "amd_iommu=on"
    else "intel_iommu=on";

  # GPU passthrough hook — auto-detects discrete GPU at VM start/stop.
  # Rename your Windows VM to "windows" in virt-manager.
  gpuHook = pkgs.writeShellScript "qemu-vfio-hook" ''
    VM_NAME="$1"
    OPERATION="$2"
    SUB_OP="$3"

    [[ "$VM_NAME" != "windows" ]] && exit 0

    find_gpu() {
      lspci -D | grep -iE "VGA compatible|3D controller|Display controller" \
               | grep -iv "intel" \
               | head -1 \
               | awk '{print $1}'
    }

    gpu_base_from_addr() {
      echo "$1" | rev | cut -d. -f2- | rev
    }

    bind_vfio() {
      local gpu_addr gpu_base dev driver_link orig_driver
      gpu_addr=$(find_gpu)
      [[ -z "$gpu_addr" ]] && exit 1
      gpu_base=$(gpu_base_from_addr "$gpu_addr")

      for dev_path in /sys/bus/pci/devices/$gpu_base.*; do
        dev=$(basename "$dev_path")
        driver_link="$dev_path/driver"
        if [[ -L "$driver_link" ]]; then
          orig_driver=$(basename "$(readlink "$driver_link")")
          echo "$orig_driver" > "/tmp/vfio_orig_$dev"
          echo "$dev" > "/sys/bus/pci/drivers/$orig_driver/unbind"
        fi
        echo "vfio-pci" > "$dev_path/driver_override"
        echo "$dev" > /sys/bus/pci/drivers/vfio-pci/bind
      done
    }

    unbind_vfio() {
      local gpu_addr gpu_base dev orig_driver
      gpu_addr=$(find_gpu)
      [[ -z "$gpu_addr" ]] && exit 0
      gpu_base=$(gpu_base_from_addr "$gpu_addr")

      for dev_path in /sys/bus/pci/devices/$gpu_base.*; do
        dev=$(basename "$dev_path")
        echo "" > "$dev_path/driver_override"
        echo "$dev" > /sys/bus/pci/drivers/vfio-pci/unbind 2>/dev/null || true
        orig_driver=$(cat "/tmp/vfio_orig_$dev" 2>/dev/null)
        [[ -n "$orig_driver" ]] && echo "$dev" > "/sys/bus/pci/drivers/$orig_driver/bind" 2>/dev/null || true
      done
    }

    case "$OPERATION/$SUB_OP" in
      prepare/begin) bind_vfio ;;
      release/end)   unbind_vfio ;;
    esac
  '';
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
  boot.kernelParams                           = [ "quiet" iommuParam "iommu=pt" ];
  boot.initrd.verbose                         = false;
  boot.kernelModules                          = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];

  # -- Networking ----------------------------------------------------------------
  networking.hostName              = "nixos";
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

  security.polkit.enable = true;
  security.pki.certificateFiles = [
    /home/user/Documents/certs/vega_ca.crt
  ];
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
    extraGroups  = [ "networkmanager" "wheel" "video" "libvirtd" "kvm" "input" ];
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
      networkmanagerapplet
      libnotify
      fastfetch
      fortune
      lolcat
      fzf
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

      # Virtualisation
      virt-manager
      looking-glass-client
      virtiofsd
      virtio-win

      # Disk management
      gnome-disk-utility

      # Apps
      brave
      teams-for-linux
      keepass
      veracrypt
      drawio
      chezmoi
    ];
  };

  # -- System packages -----------------------------------------------------------
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nushell
    veracrypt
    python3
    tokyonight-gtk-theme
  ];

  # -- Virtualisation ------------------------------------------------------------
  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package      = pkgs.qemu;
      swtpm.enable = true;
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  # Looking Glass shared memory buffer (Windows VM → Linux framebuffer)
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 user kvm -"
  ];

  # GPU passthrough hook — binds/unbinds discrete GPU for VM named "windows"
  environment.etc."libvirt/hooks/qemu" = {
    source = gpuHook;
    mode   = "0755";
  };

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
  # GTK3/4 theme + font — affects Brave file picker, Veracrypt, GTK apps
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

  # Symlink /usr/bin/bash for tools that hardcode it (e.g. WallRizz)
  system.activationScripts.usrbinbash = {
    text = ''
      mkdir -p /usr/bin
      ln -sfn /run/current-system/sw/bin/bash /usr/bin/bash
    '';
    deps = [];
  };

  # Symlink /usr/share/applications for rofi drun and other launchers
  system.activationScripts.usrshareapps = {
    text = ''
      mkdir -p /usr/share
      ln -sfn /run/current-system/sw/share/applications /usr/share/applications
    '';
    deps = [];
  };

  # Yazi file manager — desktop entry that opens inside kitty (no Terminal=true quirks)
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

  # Set yazi-kitty as default file manager for directories
  environment.etc."xdg/mimeapps.list".text = ''
    [Default Applications]
    inode/directory=yazi-kitty.desktop
  '';

  # This value pins the NixOS release for stateful data defaults.
  # Change only when intentionally migrating state. See: man configuration.nix
  system.stateVersion = "26.05";
}
