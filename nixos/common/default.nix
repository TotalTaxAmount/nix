{
  config,
  inputs,
  host,
  lib,
  pkgs,
  user,
  ...
}:

{
  # imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];
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

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  # Experimental
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    # "totaltaxamount" #
    user
  ];

  users.users."${user}" = {
    isNormalUser = true;
    description = "";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "docker"
    ];
    packages = with pkgs; [ ];
  };

  # system.autoUpgrade = { Might be breaking shitl
  #   enable = true;
  #   channel = "https://nixos.org/channels/unstable";
  # };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.noto
      nerd-fonts.overpass

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

    #    lowLatency = {
    #     enable = true;
    #  };
  };
  services.gnome.gnome-keyring.enable = true;
  services.pcscd.enable = true;


  services.auto-cpufreq = {
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

  environment.systemPackages = with pkgs; [ 
    nix-output-monitor

    man-pages
    man-pages-posix
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "code";
    NVD_BACKEND = "direct";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  programs.zsh = {
    enable = true;
  };

  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.fstrim = {
    enable = true;
  };

  security.apparmor = {
    enable = false;
    enableCache = false;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez-experimental;
      settings.Policy.AutoEnable = "true";
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
  };

  security.polkit = {
    enable = true;
  };

  networking = {
    hostName = host;
    nftables.enable = false;
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

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  nix.settings.auto-optimise-store = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
