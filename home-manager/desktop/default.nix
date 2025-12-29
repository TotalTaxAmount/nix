{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  utils = import ../../modules/utils.nix {
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
    ../../modules/hypr/hyprland.nix
    ../../modules/hypr/hyprlock.nix
    ../../modules/alacritty
    ../../modules/rofi
    ../../modules/eww
    ../../modules/dunst
    ../../modules/vscode

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

    nixpkgs.config.allows = true;

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
        package = (pkgs.obs-studio.override {
          cudaSupport = true;
        });
      };
    };

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
      piper
      slack
      copyq
      rofi-copyq
      blender
      # davinci-resolve
      audacity
      jetbrains.idea-ultimate
      lunar-client
      nemo
      (zoom-us.override {
        hyprlandXdgDesktopPortalSupport = true;
      })
      noita_entangled_worlds
      freecad-wayland
    

      # Terminal
      zsh-powerlevel10k
      neofetch
      file
      playerctl
      tree
      hyprpaper

      # Utils
      ffmpeg
      killall
      wl-screenrec
      utils.print-colors
      jq
      socat
      bat
      openal
      # qt5.full
      wget
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      slurp

      # keyboard
      qmk

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

      # Virt
      virt-manager
      virt-viewer
      spice 
      spice-gtk
      spice-protocol
      win-spice
      kicad
      adwaita-icon-theme
      virtiofsd
    ];

    gtk.theme = {
      package = pkgs.lavanda-gtk-theme;
      name = "Lavanda-Dark";
    };
  };
}
