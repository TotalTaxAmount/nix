{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:

{
  imports = [ ./hardware.nix ];

  services.xserver = {
    enable = true;
    videoDrivers = lib.mkDefault [ "nvidia" ];

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
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

    flipperzero.enable = true;

    nvidia = {
      modesetting.enable = lib.mkDefault true;
      powerManagement = {
        enable = lib.mkDefault true;
      };

      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    xpadneo.enable = true;
    steam-hardware.enable = true;
  };

  services = { 
    blueman.enable = true; 
    fstrim.enable = true;

    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
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
  ];

  environment.variables = { 
    EDITOR = "nvim"; 
    VISUAL = "code";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
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

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
  

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing.enable = true;

    pcscd.enable = true;

    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';
  };

  networking = {
    hostName = "desktop";
    nftables.enable = false;
    firewall = {
      enable = true;
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  security.pam.services.hyprlock = {
    text = ''
      auth include login
    '';
  };

  # security.wrappers.gamescope = {
  #   owner = "root";
  #   group = "root";
  #   capabilities="cap_sys_nice+eip";
  #   source = "${pkgs.gamescope}/bin/gamescope";
  # };

  boot = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "kvm-amd" ];

    tmp.cleanOnBoot = true;

    kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };

    loader = {
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };

      grub = {
        efiSupport = true;
      };
    };
  };
}
