{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:

{
  imports = [
    ./hardware.nix
    ../../modules/wireguard
    inputs.sops-nix.nixosModules.default
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  services = {
    spice-vdagentd.enable = true;
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

    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          scaling_min_freq = 800000;
        };
        battery = {
          scaling_min_freq = 500000;
        };
      };
    };

    blueman.enable = true;
    printing.enable = true;
  };

  security.pam.services.hyprlock = {
    text = ''
      auth include login
    '';
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    flipperzero.enable = true;

    nvidia = {
      modesetting.enable = lib.mkDefault true;

      open = false; # Issues with open drives
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;

      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:65:0:0";
      };
    };

    xpadneo.enable = true;
    steam-hardware.enable = true;
  };

  sops = {
    # Secrets
    defaultSopsFile = ./secrets/secrets.yml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets."wireguard/private_key" = { };
  };

  programs = {
    dconf.enable = true;

    hyprland = {
      # Need this for gdm to work
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${system}.hyprland;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    coolercontrol = {
      enable = true;
      nvidiaSupport = true;
    };

    rog-control-center.enable = true;
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # SSH
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    bluez-experimental
    bluez-tools
    bluez-alsa
    brightnessctl
    sqlite
    libnotify
    pinentry-curses
  ];

  virtualisation = {
    waydroid.enable = true;
    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };

    podman = {
      enable = true;

      dockerCompat = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  boot = {
    kernelParams = [
      "acpi_backlight=native" # Fix backlight not working
    ];

    supportedFilesystems = [ "nfs" ];
    kernelModules = [
      "kvm-amd"
    ];
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_cachyos;

    # Star citizen
    kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
