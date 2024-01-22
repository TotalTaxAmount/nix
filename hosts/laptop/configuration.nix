
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, lib, pkgs, ... }:

let

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ../../modules/system/wireguard
      inputs.sops-nix.nixosModules.default
    ];
  nix.settings.trusted-users = [ "totaltaxamount" /* TODO: use the user varbile*/ ];

  
  # Configure  X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    enable = true;
    videoDrivers = ["nvidia"];

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  services.supergfxd.enable = true;

  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  systemd.services.asusd.wantedBy = lib.mkForce [ "multi-user.target" ];

  programs.ssh = {
    forwardX11 = true;
  };
  
  hardware = {
    opengl = {
    	enable = true;
      driSupport = true;
      driSupport32Bit = true;
      setLdLibraryPath = true; 

      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    nvidia = {
      modesetting.enable = true; 
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:5:0:0";
       };
    };

    xpadneo.enable = true;
    bluetooth.enable = true;
    steam-hardware.enable = true;
  };
  services.blueman.enable = true;
    # hardware.openrgb = {
    #   enable = true;
    #   motherboard = "amd";
    # };


  sops = {
    defaultSopsFile = ./secrets/secrets.yml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
      
    # Secrets
    secrets."wireguard/private_key" = {
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."totaltaxamount" = {
    isNormalUser = true;
    description = "Coen Shields";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker"];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alsa-utils
    brightnessctl
    sqlite
    libnotify
    pinentry-curses
    xwaylandvideobridge
  ];

  # Need this for gdm to work
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };

   # Needed for swaylock
  security.pam.services.swaylock = {};

  # Why not home-manager??
  programs.steam = {
     enable = true;
     remotePlay.openFirewall = true;
     dedicatedServer.openFirewall = true;
  };

  services.avahi.enable = true;
  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };
  
  networking = {
    hostName = "laptop";
    nftables.enable = false;
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];

      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
      allowedTCPPorts = [ 22 /* SSH */];
    };
  };

  # Boot loader
  boot.kernelParams = [ 
    "video=eDP-1:1920x1080@60" # TODO: There is def a better way to do this...
    #"amd_iommu=on" # GPU passthough
   ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel"]; # Needed for vm
  boot.tmp.cleanOnBoot = true;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  services.logind.extraConfig = ''
    	HandlePowerKey=ignore
  '';

  # VMs
  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = false;
    docker.enable = false;
  };

  swapDevices = [ 
    { 
      device = "/var/lib/swapfile";
      size = 32 * 1024; 
      }
    ];

}
