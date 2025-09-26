{
  config,
  pkgs,
  inputs,
  user,
  lib,
  ...
}:

let

  # Custom pkgs
  rofi-copyq = pkgs.callPackage ../../external/pkgs/rofi-copyq { };
  noita-worlds = pkgs.callPackage ../../external/pkgs/noita-worlds { };
  utils = import ../../modules/utils.nix {
    inherit
      lib
      pkgs
      inputs
      config
      ;
  };
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

    # Flakes
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


    nixpkgs.config.allowUnfree = true;

    services = {
      hypridle = {
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
            on-timeout = "kill $(pgrep eww)";
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

      spotifyd.enable = true;
    };

    programs = {
      obs-studio = {
        enable = true;
        package = (pkgs.obs-studio.override { cudaSupport = true; });
      };
    };

    home.packages = with pkgs; [
      # Apps
      freecad-qt6
      gimp
      spotify
      qFlipper
      prismlauncher
      firefox-devedition
      # element-desktop
      vesktop
      zoom-us
      ghidra
      obsidian
      bitwarden-desktop
      pulseview
      gthumb
      wl-screenrec
      clapper
      ffmpeg
      killall
      utils.print-colors
      nautilus
      # postman
      nomacs
      qbittorrent
      slack
      freecad-wayland
      # davinci-resolve
      audacity

      #Terminal Apps/Config
      zsh-powerlevel10k
      file
      playerctl
      tree

      #Utils
      jq
      socat
      #      nvtop
      glxinfo
      bat
      openal

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
      # (jetbrains.idea-ultimate.override {
      #   jdk = pkgs.openjdk21; # TODO: https://github.com/NixOS/nixpkgs/issues/426815
      # })

      # Game utils
      #    lutris
      wineWowPackages.waylandFull
      #   gamescope    
      winetricks
      mangohud
      gamemode
      noita-worlds
      protonplus
      # inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge

      # Screenshot
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      slurp

      # Clipboard
      copyq

      # Virt
      distrobox
      virt-manager
      virt-viewer
      spice 
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
      virtiofsd

      # Fonts
      font-awesome
    ];

    gtk.theme = {
      package = pkgs.lavanda-gtk-theme;
      name = "Lavanda-Dark";
    };
  };
}
