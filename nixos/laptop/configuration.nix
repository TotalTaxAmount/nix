{
  config,
  inputs,
  lib,
  pkgs,
  system,
  user,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../modules/wireguard
    ../../modules/vfio
    inputs.sops-nix.nixosModules.default
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.lsfg-vk.nixosModules.default
  ];

  virtualisation.vfio.enable = false;

  zramSwap.enable = true;
  services = {
    ratbagd.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    spice-vdagentd.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [
        "amdgpu"
        "nvidia"
        # "displaylink"
      ];
    };

    displayManager.ly = {
      enable = true;
      settings = {
        save = true;
        defualt_user = user;
        clear_password = true;
      };
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };


    udev = {
      packages = [
        pkgs.platformio-core.udev
        pkgs.openocd
        pkgs.keychron-udev-rules
      ];

      # Hyprland iGPU/dGPU path
      extraRules = ''
        KERNEL=="card*", KERNELS=="0000:65:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/amd-igpu"
        KERNEL=="card*", KERNELS=="0000:01:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/nvidia-gpu"
        KERNEL=="card*", KERNELS=="evdi.0", SUBSYSTEM=="drm", SUBSYSTEMS=="platform", SYMLINK+="dri/evdi-gpu"

        SUBSYSTEM=="pci", ATTRS{vendor}=="0x10de", ATTRS{device}=="0x2860", ATTR{power/control}="auto", ATTR{power/autosuspend_delay_ms}="1000"

        ACTION=="add|change", KERNEL=="nvme0n1", ATTR{queue/scheduler}="mq-deadline"
        ACTION=="add|change", KERNEL=="nvme0n1", ATTR{queue/wbt_lat_usec}="500"

      '';
    };

    lsfg-vk = {
      enable = true;
      ui.enable = true;
    };

    asusd = {
      enable = true;

      asusdConfig.text =
        ''
          (
            charge_control_end_threshold: 100,
            base_charge_control_end_threshold: 100,
            disable_nvidia_powerd_on_battery: true,
            ac_command: "",
            bat_command: "",
            platform_profile_linked_epp: true,
            profile_quiet_epp: Power,
            profile_balanced_epp: BalancePower,
            profile_performance_epp: Performance,
            platform_profile_on_battery: Quiet,
            change_platform_profile_on_battery: true,
            platform_profile_on_ac: Performance,
            change_platform_profile_on_ac: true,
            ac_profile_tunings: {
                Performance: (
                    enabled: false,
                    group: {},
                ),
            },
            dc_profile_tunings: {},
            armoury_settings: {},
        )
      '';
    };

    blueman.enable = true;
    printing.enable = true;
  };

  security = {
    tpm2.enable = true;
    pam.services = {
      hyprlock = {
        text = ''
          auth include login
        '';
      };

      ly.enableGnomeKeyring = true;
      hyprland.enableGnomeKeyring = true;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    nvidia-container-toolkit.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libva-vdpau-driver
        nvidia-vaapi-driver
        libvdpau-va-gl
      ];
    };

    flipperzero.enable = true;

    nvidia = {
      modesetting.enable = lib.mkDefault true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };

      dynamicBoost.enable = true;

      nvidiaPersistenced = true;

      open = true; # Issues with open drives
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;

      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:65:0:0";
      };
    };

    xpadneo.enable = false;
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
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${system}.hyprland;
      withUWSM = false;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    rog-control-center.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [ avrdude ];
    };
  };

  networking = {
    nameservers = [ "1.1.1.1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";

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
    pinentry-gnome3
    # displaylink

    # Need these here for zed decontainer ig
    docker
    docker-compose
  ];

  environment.variables = {
    # DOCKER_HOST = "unix:///run/podman/podman.sock";
  };

  virtualisation = {
    # waydroid.enable = true;
    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };

    # podman = {
    #   enable = true;
    #   enableNvidia = true;

    #   dockerCompat = true;
    #   dockerSocket.enable = true;

    #   defaultNetwork.settings.dns_enabled = true;
    # };
    #
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };

  powerManagement = {
    cpuFreqGovernor = "powersave";
    powertop.enable = false;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.libvirtd.serviceConfig.LoadCredentialEncrypted = "";

  boot = {
    kernelParams = [
      "acpi_backlight=native" # Fix backlight not working
      "amd_pstate=active"
    ];

    extraModprobeConfig = ''
      options nvidia NVreg_DynamicPowerManagement=0x03
      options nvidia NVreg_EnableGpuFirmware=1
    '';

    # extraModulePackages = [ config.boot.kernelPackages.evdi ];

    supportedFilesystems = [ "nfs" ];
    kernelModules = [
      "kvm_amd"
      "nvidia" # Shouln't have to do this but ok
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "evdi"
    ];


    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;

    # Games
    kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
      "vm.dirty_background_bytes" = 67108864;
      "vm.dirty_bytes" = 134217728;
      "vm.dirty_expire_centisecs" = 1000;
      "vm.dirty_writeback_centisecs" = 100;
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
      pkiBundle = "/etc/secureboot";
    };
  };
}
