{
  config,
  pkgs,
  inputs,
  user,
  lib,
  host,
  system,
  ...
}:

let
  # Flake stuff
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;

  # Custom pkgs
  rofi-copyq = pkgs.callPackage ../../../external/pkgs/rofi-copyq { };
  path-planner = pkgs.callPackage ../../../external/pkgs/pathplanner { };
  utils = import ../modules/utils.nix {
    inherit
      lib
      pkgs
      inputs
      config
      ;
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  imports = [
    ../modules/hypr/hyprland.nix
    ../modules/hypr/hyprlock.nix
    ../modules/alacritty
    ../modules/rofi
    ../modules/eww
    ../modules/dunst
    ../modules/vscode

    # Flakes
    inputs.spicetify-nix.homeManagerModule
    inputs.nix-colors.homeManagerModule
    inputs.sops-nix.homeManagerModule
  ];

  config = {
    # System theme
    # Use custom themes customThemes.[theme] (defined in themes/custom.nix) or inputs.nix-colors.colorSchemes.[theme] themes list at https://github.com/tinted-theming/base16-schemes
    colorScheme = utils.customThemes.material-ocean;
    font = "FiraCode Nerd Font";

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 16;
    };

    home.username = user;
    home.homeDirectory = "/home/${user}";

    # Unfree stuff/Insecure
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [ "qtwebkit-5.212.0-alpha4" ];

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')

      # Apps
      gimp
      spotify
      #  audacity
      qFlipper
      prismlauncher
      firefox-devedition
      #   android-studio
      element-desktop
      vesktop
      #   pathplanner

      pulseview
      # gfn-electron
      #      kicad
      gthumb
      wl-screenrec
      clapper
      ffmpeg
      killall
      utils.print-colors
      nautilus
      # zed-editor
      # path-plannesr

      # fluent-reader
      nomacs
      #bottles
      qbittorrent
      # virt-manager
      blender
      slack

      #Terminal Apps/Config
      zsh-powerlevel10k
      neofetch
      file
      playerctl
      base16-builder
      tree

      #Utils
      jq
      socat
      #      nvtop
      glxinfo
      bat
      openal
      qt5.full
      wget
      rofi-copyq
      gammastep

      #Customization
      swww

      # Scripts
      python3
      nodejs
      gcc

      # IDEs
      #     jetbrains.clion
      jetbrains.idea-ultimate

      # Game utils
      #    lutris
      wineWowPackages.waylandFull
      #   gamescope    
      winetricks
      mangohud
      gamemode
      # inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge

      # Screenshot
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      slurp

      # Clipboard
      copyq

      # Virt
      distrobox

      # Fonts
      nerdfonts
      font-awesome
    ];

    programs.spicetify = {
      enable = false;
      theme = spicePkgs.themes.Ziro;
      colorScheme = "ziro";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        hidePodcasts
        songStats
        powerBar
      ];
    };

    services.kdeconnect = {
      enable = true;
    };

    services.spotifyd.enable = true;

    dconf.settings = {

    };

    gtk.theme = {
      package = pkgs.lavanda-gtk-theme;
      name = "Lavanda-Dark";
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
        };

        listener = [
          {
            timeout = 120;
            on-timeout = "eww close laptopMain || kill $(pgrep eww)";
            on-resume = " ${pkgs.eww}/bin/eww open laptopMain";
          }
          {
            timeout = 500;
            on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];

      };
    };

    programs.git = {
      enable = true;
      userEmail = "shieldscoen@gmail.com";
      userName = user;
    };
    # Random files

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
