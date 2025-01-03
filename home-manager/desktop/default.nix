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
  utils = import ../modules/utils.nix {
    inherit
      lib
      pkgs
      inputs
      config
      ;
  };
  rofi-copyq = pkgs.callPackage ../../external/pkgs/rofi-copyq { };
  noita_entangled_worlds = pkgs.callPackage ../../external/pkgs/noita-worlds { };
in
{
  imports = [
    ../modules/hypr/hyprland.nix
    ../modules/hypr/hyprlock.nix
    ../modules/alacritty
    ../modules/rofi
    ../modules/eww
    ../modules/dunst
    ../modules/vscode

    inputs.spicetify-nix.homeManagerModules.default
    inputs.nix-colors.homeManagerModule
  ];

  config = {
    colorScheme = utils.customThemes.material-ocean;
    font = "FiraCode Nerd Font";

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 16;
    };

    home.username = user;
    home.homeDirectory = "/home/${user}";

    nixpkgs.config.allows = true;

    home.stateVersion = "23.05";

    home.packages = with pkgs; [
      # Apps
      gimp
      spotify
      qFlipper
      prismlauncher
      firefox-devedition
      element-desktop
      vesktop
      r2modman
      libreoffice
      pulseview
      gthumb
      clapper
      qbittorrent
      # ble nder
      piper
      slack
      copyq
      rofi-copyq
      jetbrains.idea-ultimate
      lunar-client
      nemo
      zoom-us
      noita_entangled_worlds
      # heroic
      freecad-wayland

      # Terminal
      zsh-powerlevel10k
      neofetch
      file
      playerctl
      base16-builder
      tree
      hyprpaper

      # Utils
      ffmpeg
      killall
      wl-screenrec
      utils.print-colors
      jq
      socat
      glxinfo
      bat
      openal
      qt5.full
      wget
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      slurp

      # Virt
      distrobox

      # Customization/Fonts
      swww
      font-awesome

      # Game Stuff
      wineWowPackages.waylandFull
      winetricks
      protontricks
      mangohud
      gamescope
      gamemode
      protonplus
      lutris
      inputs.nix-citizen.packages.${pkgs.system}.lug-helper

      # Scripts/Misc
      python3
      nodejs
      gcc
    ];

    services = {
      spotifyd.enable = true;

      easyeffects.enable = true;

      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on && kill $(pgrep eww) && ${pkgs.eww}/bin/eww open-many main0 main1";
            ignore_dbus_inhibit = false;
            lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
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
    };

    programs = {
      obs-studio = {
        enable = true;
      };
    };

    wayland.windowManager.hyprland = {
      #      enable = true;
      #      xwayland.enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland-legacy-renderer;
    };

    gtk.theme = {
      package = pkgs.lavanda-gtk-theme;
      name = "Lavanda-Dark";
    };

    programs.home-manager.enable = true;
  };
}