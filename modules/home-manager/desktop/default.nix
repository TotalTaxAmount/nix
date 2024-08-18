{
  config,
  pkgs,
  inputs,
  user,
  lib,
  host,
  ...
}: 

let 
    utils = import ../modules/utils.nix { inherit lib pkgs inputs config; };
    rofy-copyq = pkgs.callPackage ../../../external/pkgs/rofi-copyq { };
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

    inputs.spicetify-nix.homeManagerModule
    inputs.nix-colors.homeManagerModule
  ];

  config = {
    colorScheme = utils.customThemes.material-ocean;
    font = "FiraCode Nerd Font";

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
      ghidra
      pulseview
      gthumb
      clapper
      qbittorrent
      blender
      slack
      copyq
      rofi-copyq

      # Terminal
      zsh-powerlevel10k
      neofetch
      file
      playerctl
      base16-builder
      tree

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
      nerdfonts
      font-awesome

      # Game Stuff
      wineWowPackages.waylandFull
      winetricks
      protontricks
      mangohud
      gamemode

      # Scripts/Misc
      python3
      nodejs
      gcc
    ];
  };

  services.kdeconnect = {
    enable = true;
  };

  services = {
    spotifyd.enable = true;

    hypridle = {
      enable = true;
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
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

  programs = {
    git = {
      enable = true;
      userEmail = "shieldscoen@gmail.com";
      userName = user;
    };
  };

  gtk = {
    enable = true;

    theme = {
      package = utils.nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
      name = config.colorScheme.name;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Extra Files 
  home.file.".config/mimeapps.list".source = ../../../dots/mimeapps.list;

  programs.home-manager.enable = true;
}