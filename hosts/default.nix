{ config, inputs, lib, user, pkgs, ... }:

{
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];
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

  # system.autoUpgrade = { Might be breaking shitl
  #   enable = true;
  #   channel = "https://nixos.org/channels/unstable";
  # };


  fonts = {
    packages = with pkgs; [
        (nerdfonts.override {fonts = [ "Overpass" "FiraCode" "Noto"];})
        
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Emoji" ];
      };
    };
    enableDefaultPackages = true;
  };

  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    lowLatency = {
      enable = true;
    };
  };


  programs.zsh = {
     enable = true; 
  };

  boot.loader = {
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
        }'';
    };
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

  system.stateVersion = "23.05"; # Did you read the comment?
}