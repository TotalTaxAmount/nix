
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, lib, user, pkgs, ... }:

let
  user="totaltaxamount"; #TODO: Fix this later
  genAddress = number: "10.1.11.${toString number}/32";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      inputs.sops-nix.nixosModules.default
    ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  nix.settings.trusted-users = ["totaltaxamount"];

  
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
  
  hardware = {
    opengl = {
    	enable = true;
      driSupport = true;
      driSupport32Bit = true;
      setLdLibraryPath = true; 
    };

    nvidia = {
      modesetting.enable = true; 
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
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
  services = {
    blueman.enable = true;
    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };
  };

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
  users.users.${user} = {
    isNormalUser = true;
    description = "Coen Shields";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
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
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };
  
  networking.nftables.enable = false;
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];

    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];

    allowedUDPPorts = [ 51820 /* Wireguard VPN */ ];
    allowedTCPPorts = [ 22 /* SSH */];
  };

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.1.11.2/24" ];

      listenPort = 51820;


      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${genAddress 2} -o wlp3s0 -j MASQUERADE
      '';

      # Undo the above
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${genAddress 2} -o wlp3s0 -j MASQUERADE
      '';

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          publicKey = "kE24u6RmvQDkOT8JSgx7tHzkwkeRywh8ofA6NLel9z0=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "totaltax.ddns.net:51820";
          persistentKeepalive = 25;
        }
      ];

    };
  };
  
  # Boot loader
  boot.kernelParams = [ 
    "video=eDP-1:1920x1080@165" # TODO: There is def a better way to do this...
    #"amd_iommu=on" # GPU passthough
   ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel"]; # Needed for vm
  boot.tmp.cleanOnBoot = true;
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = lib.mkOverride 98 true;
    "net.ipv4.conf.default.forwarding" = lib.mkOverride 98 true;
  };

  services.logind.extraConfig = ''
    	HandlePowerKey=ignore
  '';

  # VMs
  virtualisation.libvirtd.enable = true;
}
