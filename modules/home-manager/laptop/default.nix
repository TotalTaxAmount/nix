{
  config,
  pkgs,
  inputs,
  user,
  lib,
  ...
}:

let
  # Custom color themes
  customThemes = import ../../../theme/custom.nix;
  base16Themes = inputs.nix-colors.colorSchemes;

  # Flake stuff
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };

  # Custom pkgs
  rofi-copyq = pkgs.callPackage ../../../external/pkgs/rofi-copyq { };

  # https://gist.github.com/corpix/f761c82c9d6fdbc1b3846b37e1020e11 TODO: just source this gist
  pow =
    let
      pow' =
        base: exponent: value:
        # FIXME: It will silently overflow on values > 2**62 :(
        # The value will become negative or zero in this case
        if exponent == 0 then
          1
        else if exponent <= 1 then
          value
        else
          (pow' base (exponent - 1) (value * base));
    in
    base: exponent: pow' base exponent base;

  hexToDec =
    v:
    let
      hexToInt = {
        "0" = 0;
        "1" = 1;
        "2" = 2;
        "3" = 3;
        "4" = 4;
        "5" = 5;
        "6" = 6;
        "7" = 7;
        "8" = 8;
        "9" = 9;
        "a" = 10;
        "b" = 11;
        "c" = 12;
        "d" = 13;
        "e" = 14;
        "f" = 15;
      };
      chars = lib.stringToCharacters v;
      charsLen = lib.length chars;
    in
    lib.foldl (a: v: a + v) 0 (lib.imap0 (k: v: hexToInt."${v}" * (pow 16 (charsLen - k - 1))) chars);

  print-colors = pkgs.writeScriptBin "print_colors" ''
    #!${pkgs.bash}/bin/bash
    ${lib.concatMapStringsSep "\n"
      (
        color:
        let
          hexColor = config.colorScheme.palette."${color}";
          r = hexToDec (builtins.substring 0 2 hexColor);
          g = hexToDec (builtins.substring 2 2 hexColor);
          b = hexToDec (builtins.substring 4 2 hexColor);
        in
        ''
          echo -e "${color} = #${hexColor} \e[48;2;${toString r};${toString g};${toString b}m    \e[0m"
        ''
      )
      [
        "base00"
        "base01"
        "base02"
        "base03"
        "base04"
        "base05"
        "base06"
        "base07"
        "base08"
        "base09"
        "base0A"
        "base0B"
        "base0C"
        "base0D"
        "base0E"
        "base0F"
      ]
    }
  '';
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
    colorScheme = customThemes.material-ocean;
    font = "FiraCode Nerd Font";

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
      ghidra
      pulseview
      # gfn-electron
      #      kicad
      gthumb
      wl-screenrec
      clapper
      ffmpeg
      killall
      print-colors
      # zed-editor

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
      asusctl

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

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      # enableNvidiaPatches = true;
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 900;
            on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];

      };
    };

    programs.git = {
      enable = true;
      userEmail = "shieldscoen@gmail.com";
      userName = "TotalTaxAmount";
    };

    gtk = {
      enable = true;

      theme = {
        package = nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
        name = config.colorScheme.name;
      };
    };

    # Random files
    home.file.".config/mimeapps.list".source = ../../../dots/mimeapps.list;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
