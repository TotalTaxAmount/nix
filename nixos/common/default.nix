{
  host,
  lib,
  pkgs,
  user,
  ...
}:

{
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

  nix.settings.experimental-features = [
    # Not sure if this is still needed
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
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
      "dialout"
    ];
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "code";
    NVD_BACKEND = "direct";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

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

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez-experimental;
      settings.Policy.AutoEnable = "true";
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = host;
    nftables.enable = false;
  };

  services = {
    fwupd.enable = true;
    automatic-timezoned.enable = true;
    xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    gnome.gnome-keyring.enable = true;
    pcscd.enable = true;
    fstrim.enable = true;
  };

  security = {
    rtkit.enable = true; # Need for pipewire
    polkit.enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    man-pages
    man-pages-posix

    sbctl # Secure boot
  ];

  xdg.mime.defaultApplications = {
    "image/jpeg" = "org.gnome.gThumb.desktop";
    "image/png" = "org.gnome.gThumb.desktop";
    "image/gif" = "org.gnome.gThumb.desktop";
    "image/webp" = "org.gnome.gThumb.desktop";
    "image/bmp" = "org.gnome.gThumb.desktop";
    "image/tiff" = "org.gnome.gThumb.desktop";
    "image/svg+xml" = "org.gnome.gThumb.desktop";
    };

  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest; # Use vanilla kernel by default
  };

  # Enable grable collection of the nix store to decrease disk usage
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  nix.settings.auto-optimise-store = true;

  system.stateVersion = "25.05"; # Don't change unless changelog says to
}
