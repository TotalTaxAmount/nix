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

      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    xpadneo.enable = true;
    steam-hardware.enable = true;
  };

  services = {
    blueman.enable = true;
    fstrim.enable = true;

    openvpn = {
      servers = {
        vpnbookUK = {
          config = "config /home/${user}/VPNs/vpnbook-uk205-udp25000.ovpn";
          autoStart = false;
        };
      };
    };

    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    seatd = {
      enable = true;
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
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  programs = {
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

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "preformace";
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing.enable = true;

    pcscd.enable = true;

    flatpak.enable = true;

    # logind.extraConfig = ''
    #   HandlePowerKey=ignore
    # '';
  };

  networking = {
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
  # chaotic = {
  #   scx.enable = true;
  # };

  chaotic = {
    # scx = {
    #   enable = true;
    #   scheduler = "scx_rusty";
    # };
  };

  boot = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_cachyos;

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
