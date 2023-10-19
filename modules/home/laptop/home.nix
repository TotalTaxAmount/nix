{ config, pkgs, inputs, user, ... }:

let
  # Custom color themes
  customThemes = import ../theme/custom.nix;
  base16Themes = inputs.nix-colors.colorSchemes;

  # Flake stuff
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
  
  # Custom pkgs (gonna do this better sometime ;))
  flight-core = pkgs.callPackage ./custom-pkgs/flightcore/flightcore.nix {};
  candyIcons = pkgs.callPackage ../modules/home/icons/candy-icons.nix {};
  schemer2 = pkgs.callPackage ./custom-pkgs/schemer2.nix {};
  rofi-copyq = pkgs.callPackage ./custom-pkgs/rofi-copyq/rofi-copyq.nix {};
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  imports = [
        ../modules/home/nvim
        ../modules/home/hypr
        ../modules/home/alacritty
        ../modules/home/rofi
        ../modules/home/eww
        ../modules/home/btop
        ../modules/home/dunst
        ../modules/home/swaylock
        ../modules/home/xplorer
        ../modules/home/vscode
        ../modules/home/neofetch
        ../modules/home/discord
        ../modules/home/prismLauncher

        # Flakes
        inputs.spicetify-nix.homeManagerModule
        inputs.nix-colors.homeManagerModule
        inputs.sops-nix.homeManagerModule
  ];

  options = {
    font = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      example = "Noto Fonts";
      description = "
        Name of system font (make sure its installed)
      ";
    };
  };

  config = {  
    # System theme
    # Use custom themes customThemes.[theme] (defined in themes/custom.nix) or inputs.nix-colors.colorSchemes.[theme] themes list at https://github.com/tinted-theming/base16-schemes
    colorScheme = base16Themes.twilight;
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
      brave
      fluent-reader
      nomacs
      bottles
      qbittorrent
      virt-manager
      blender

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

      slack
      
      # IDEs
      jetbrains.clion
      jetbrains.idea-ultimate

      # Games
      mangohud
      gamemode
      nvtop

      # Screenshot
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      slurp
     
      # Clipboard
      copyq
      
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idle1timeout=3600000
      # '';
    };

    # You can also manage environment variables but you will have to manually
    # source
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # o
    #
    #  /etc/profiles/per-user/totaltaxamount/etc/profile.d/hm-session-vars.sh
    #
    # if you don't want to manage your shell through Home Manager.
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
      enableNvidiaPatches = true;
    };

    programs.git = {
      enable = true;
      userEmail = "shieldscoen@gmail.com";
      userName = "TotalTaxAmount";
    };

    gtk = {
      enable = true;
      iconTheme = { 
          name = "Candy Icons";
          package = candyIcons;
      };

      # theme = {
      #   package = nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
      #   name = "System Theme";
      # };
    };


    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
