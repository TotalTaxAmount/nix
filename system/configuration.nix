
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, user... }:

let
  lol="a";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./machines/laptop.nix
      #<home-manager/nixos>
    ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Experimental
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nix.settings.trusted-users = ["totaltaxamount"];
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  system.autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/unstable";
  };
  
  fonts = {
    packages = with pkgs; [
        (nerdfonts.override {fonts = [ "Overpass" ];})
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Emoji" ];
      };
    };
    
    enableDefaultPackages = true;
  
  };
  
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

  services.openvpn.servers = {
     homeVPN = {config = '' config /home/totaltaxamount/VPN/home.ovpn'';};
  };

  # Pipewire
  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable  = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware = {
    opengl = {
    	enable = true;
	driSupport = true;
	driSupport32Bit = true;
    };
    nvidia = {
       modesetting.enable = true; 
       powerManagement.enable = true;
       open = true;
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Coen Shields";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
 environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # dev

    # customistation
    rofi-wayland
    swww
    eww-wayland

    # audio
    alsa-utils
    
    # lighting
    brightnessctl

    sqlite

    # other
  ];

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };

  programs.zsh = {
     enable = true; 
  };

  # Why not home-manager??
  programs.steam = {
     enable = true;
     remotePlay.openFirewall = true;
     dedicatedServer.openFirewall = true;
  };


  # Boot loader
  boot = {
    kernelParams = [ "video=eDP-1:1920x1080@165"];
    loader = {
       systemd-boot.enable = false;
       efi = {
          canTouchEfiVariables = true;
	  efiSysMountPoint = "/boot";
      };
      grub = {
	devices = [ "nodev" ];
	enable = true;
	efiSupport = true;
	useOSProber = true;
	extraEntries = ''
  	   menuentry "UEFI Firmware Settings" {
    	      echo "Booting into UEFI firmware settings..."
    	      fwsetup
  	   }
	'';
      };
    };
  };

  services.logind.extraConfig = ''
	HandlePowerKey=ignore
  '';


  # Overlays

  system.stateVersion = "23.05"; # Did you read the comment?

 # home-manager.users.${user} = { pkgs, ...}: {
 #   home.stateVersion = "23.05";
 #   home.packages = with pkgs; [ htop ];
 # 
 #   services.dunst = {
 # 	enable = true;
 #   };
 #
 #   programs.zsh.enable = true;
 #   programs.zsh.oh-my-zsh = {
 #	enable = true;
 #       plugins = ["git" "sudo"];
 #   };
 #
 #   programs.neovim = {
 #	enable = true;
 #	defaultEditor = true;
 #       plugins = with pkgs.vimPlugins; [ vim-nix ];
 #
 #  };
 # };

}
