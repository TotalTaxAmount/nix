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
        intel-media-driver
        intel-ocl
        intel-vaapi-driver
        nvidia-vaapi-driver
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
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    xpadneo.enable = true;
    steam-hardware.enable = true;
  };

  services.blueman.enable = true;

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

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
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

  security.pam.services = {
    hyprlock.text = ''
      auth include loginc
    '';
  };

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
