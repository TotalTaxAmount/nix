
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, lib, pkgs, user, ... }:

let

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ./wireguard
      ./vfio
      inputs.sops-nix.nixosModules.default
    ];
  nix.settings.trusted-users = [ "totaltaxamount" /* TODO: use the user varbile*/ ];

  
  # fileSystems."/data/truenas" = {
  #   device = "10.1.10.3:/mnt/main/totaltaxamount";
  #   fsType = "nfs";
  #   options = ["x-systemd.idle-timeout=600"];
  # };
  #  systemd.services.data-truenas.wantedBy = lib.mkForce [ ];


  # Configure  X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
    enable = true;
    videoDrivers = lib.mkDefault ["nvidia"];

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

  systemd = {
    enableCgroupAccounting = true;
    services = {
      asusd.wantedBy = lib.mkForce [ "multi-user.target" ];
      };
    };

 programs.ssh = {
   forwardX11 = true;
 };
  
  hardware = {
    enableRedistributableFirmware = true;
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

    flipperzero.enable = true;

    nvidia = {
      modesetting.enable = lib.mkDefault true; 
      powerManagement = {
        enable = lib.mkDefault true;
      };
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

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez-experimental;
      settings.Policy.AutoEnable = "true";
      settings.General.Enable = "Source,Sink,Media,Socket";
    };

    xpadneo.enable = true;
    steam-hardware.enable = true;
  };
  services.blueman.enable = true;
    # hardware.openrgb = {
    #   enable = true;
    #   motherboard = "amd";
    # };

  


 sops = {
   defaultSopsFile = ./secrets/secrets.yml;#

   age = {
     sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
     keyFile = "/var/lib/sops-nix/key.txt";
     generateKey = true;
   };
     
   # Secrets
   secrets."wireguard/private_key" = {};
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
    bluez-experimental
    bluez-tools
    bluez-alsa
    brightnessctl
    sqlite
    libnotify
    pinentry-curses
    # xwaylandvideobridge
  ];
  # Need this for gdm to work
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # enableNvidiaPatches = true;
  };

   # Needed for swaylock
  #security.pam.services.swaylock = {};

  # Why not home-manager??
  programs.steam = {
     enable = true;
     remotePlay.openFirewall = true;
     dedicatedServer.openFirewall = true;
  };

  
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing.enable = true;
  
  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
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
   # "video=eDP-1:1920x1080@60" # TODO: There is def a better way to do this...
    "systemd.unified_cgroup_hierarchy=0"
    #"amd_iommu=on" # GPU passthough
   ];
  boot.supportedFilesystems = [ "nfs" ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  boot.tmp.cleanOnBoot = true;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };

    grub = {
      efiSupport = true;
    };	
  };

  services.logind.extraConfig = ''
    	HandlePowerKey=ignore
  '';

  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "with-vfio" ];
    vfio.enable = true;
  };

  # VMs
  virtualisation = {
    # libvirtd.enable = true;
    # waydroid.enable = true;
    docker.enable = false;

    podman = {
      enable = true;

      dockerCompat = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
}
