{ config, pkgs, inputs, user, ... }:

let
  # Custom color themes
  customThemes = import ../../../theme/custom.nix;
  base16Themes = inputs.nix-colors.colorSchemes;

  # Flake stuff
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
  
  # Custom pkgs (gonna do this better sometime ;))
  flight-core = pkgs.callPackage ../../../custom/pkgs/flightcore {};
  schemer2 = pkgs.callPackage ../../../custom/pkgs/schemer2 {};
  rofi-copyq = pkgs.callPackage ../../../custom/pkgs/rofi-copyq {};
inr/;
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  imports = [
        ./hypr
        ./alacritty
        ./rofi
        ./eww
        ./dunst
        ./swaylock
        ./vscode
        ./discord
        ./prismLauncher

        # Flakes
        inputs.spicetify-nix.homeManagerModule
        inputs.nix-colors.homeManagerModule
        inputs.sops-nix.homeManagerModule
  ];

  config = {  
    # System theme
    # Use custom themes customThemes.[theme] (defined in themes/custom.nix) or inputs.nix-colors.colorSchemes.[theme] themes list at https://github.com/tinted-theming/base16-schemes
    colorScheme = customThemes.onedark-darker;
    font = "FiraCode Nerd Font";

    home.username = user;
    home.homeDirectory = "/home/${user}";

    # Unfree stuff/Insecure
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [
      "qtwebkit-5.212.0-alpha4"
    ];

    
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
      audacity
      qFlipper

      # brave
      firefox
      fluent-reader
      nomacs
      bottles
      qbittorrent
      virt-manager
      blender
      slack

      #Terminal Apps/Config
      zsh-powerlevel10k
      neofetch
      file
      playerctl
      schemer2
      base16-builder
      tree

      #Utils
      jq
      socat
      nvtop
      glxinfo
      bat
      openal
      qt5.full
      wget
      rofi-copyq 

      #Customization
      nerdfonts
      swww

      # Langs and compilers
      python3
      nodejs
      gcc
      
      # IDEs
      jetbrains.clion
      jetbrains.idea-ultimate

      # Game utils
      lutris
      wineWowPackages.waylandFull
      gamescope    
      winetricks
      mangohud
      gamemode
      inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge

      # Screenshot
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      slurp
     
      # Clipboard
      copyq

      # Virt
      distrobox
      
    ];

    programs.spicetify = {
      enable = true;
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
  
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      # enableNvidiaPatches = true;
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
        name = "test";
      };
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
