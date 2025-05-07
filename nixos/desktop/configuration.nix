{
  config,
  inputs,
  lib,
  pkgs,
  user,
  host,
  ...
}:

{
  imports = [
    ./hardware.nix
    ../../modules/vfio.nix
    inputs.nix-citizen.nixosModules.StarCitizen
  ];

  nix.settings = {
    substituters = [ "https://nix-citizen.cachix.org" ]; # Star Citizen
    trusted-public-keys = [ "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo=" ];
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libvdpau-va-gl
        libva-vdpau-driver
        vaapiVdpau

      ];
    };

    nvidia = {
      modesetting.enable = lib.mkDefault true;

      powerManagement = {
        enable = true;
        finegrained = false;
      };

      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    nvidia-container-toolkit.enable = true;

    xpadneo.enable = true;
    steam-hardware.enable = true;
    flipperzero.enable = true;
    keyboard.qmk.enable = true;
  };

  services = {
    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    xserver = {
      enable = true;
      videoDrivers = lib.mkDefault [ "nvidia" ];

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Keychron keyboard
    udev.packages = [
      pkgs.qmk-udev-rules
    ];

    printing.enable = true;
    flatpak.enable = true;
    seatd.enable = true;
    blueman.enable = true;
  };

  programs = {
    dconf.enable = true;
    
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;

      gamescopeSession = {
        enable = true;
      };
    };

    coolercontrol = {
      enable = true;
      nvidiaSupport = true;
    };

    gamemode = {
      enable = true;
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    bluez-experimental
    bluez-tools
    bluez-alsa
    brightnessctl
    sqlint
    libnotify
    pinentry-rofi

    mesa
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  networking = {
    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];

    firewall = {
      enable = true;
    };
  };

  virtualisation = {
    spiceUSBRedirection.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  security.pam.services.hyprlock = {
    text = ''
      auth include login
    '';
  };

  boot = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [
      "kvm-amd"
      "nct6775" # For extra temp sensors
    ];

    kernelPackages = pkgs.linuxPackages_cachyos;

    tmp.cleanOnBoot = true;

    kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };

    lanzaboote = {
      enable = true; # Secure boot
      pkiBundle = "/var/lib/sbctl";
    };

    loader = {
      systemd-boot.enable = false; # Needs to be disabled for secure boot to work
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
    };
  };
}
