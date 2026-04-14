{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:

{
  imports = [
    ./hardware.nix
    inputs.nvml-tune.nixosModules.nvml
    inputs.nix-citizen.nixosModules.StarCitizen
    inputs.deadlock-api-ingest.nixosModules.default
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
        libva-vdpau-driver

      ];
    };

    nvidia = {
      modesetting.enable = lib.mkDefault true;

      powerManagement = {
        enable = true;
        finegrained = false;
      };

      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    nvidia-container-toolkit.enable = true;

    xpadneo.enable = false;
    steam-hardware.enable = true;
    flipperzero.enable = true;
    keyboard.qmk.enable = true;
  };

  services = {
    openssh = {
      enable = true;
    };

    scx = {
      enable = true;
      scheduler = "scx_bpfland";
    };

    nvml = {
      enable = true;
      gpus."0" = {
        clockOffset = 80;
        memOffset = 1500;
        powerLimit = 310000;
      };
    };

    udev.extraRules = ''
      # Basler USB cameras
      SUBSYSTEM=="usb", ATTR{idVendor}=="2676", MODE="0666", GROUP="users"
    '';

    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    xserver = {
      enable = true;
      videoDrivers = lib.mkDefault [ "nvidia" ];

    };

    displayManager.gdm = {
      enable = true;
      wayland = true;
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

    deadlock-api-ingest = {
      enable = true;
      user = "${user}";
      group = "users";
      package = inputs.deadlock-api-ingest.packages.${pkgs.system}.default;
    };

    printing.enable = true;
    flatpak.enable = true;
    seatd.enable = true;
    blueman.enable = true;
  };

  systemd.tmpfiles.rules = [
    "d /home/${user}/.local/share/deadlock-api-ingest 0755 totaltaxamount users -" # Fix deadlock-api-ingest
  ];

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
    };

    gamemode = {
      enable = true;
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    nix-ld.enable = true;
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    bluez-experimental
    bluez-tools
    bluez-alsa
    brightnessctl
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

    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        runAsRoot = true;
      };
    };

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

  zramSwap.enable = true;

  boot = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [
      "kvm-amd"
      "nct6775" # For extra temp sensors
      "zenpower"
    ];

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "usbcore.autosuspend=-1"
    ];

    extraModulePackages = [ pkgs.linuxPackages_latest.zenpower ];

    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "sd_mod"
    ];

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
