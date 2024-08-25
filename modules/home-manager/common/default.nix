{
  config,
  pkgs,
  inputs,
  user,
  lib,
  ...
}:

let
  customThemes = import ../../../theme/custom.nix;
  base16Themes = inputs.nix-colors.colorSchemes;

  # Flake stuff
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
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
  imports = [
    ../modules/btop
    ../modules/nvim
    ../modules/neofetch
    ../modules/terminal

    inputs.nix-colors.homeManagerModule

  ];
  options = {
    font = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      example = "Noto Fonts";
      description = "\n        Name of system font (make sure its installed)\n      ";
    };
  };

  config = {
    home.username = user;
    home.homeDirectory = "/home/${user}";

    # colorScheme = customThemes.onedark-darker;
    # font = "FiraCode Nerd Font";

    # Unfree stuff/Insecure
    nixpkgs.config.allowUnfree = true;

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      zsh-powerlevel10k
      neofetch
      file
      tree
      zip
      unzip

      #Utils
      nixd
      jq
      bat
      wget
      eza
      (pkgs.callPackage ../modules/shell { })

      #Customization
      nerdfonts
      inputs.mcmojave-hyprcursor.packages.${pkgs.system}.default

      # Langs and compilers
      python3
    ];

    home.sessionVariables = {
      HYPRCURSOR_THEME = "McMojave";
      XDG_SCREENSHOTS_DIR = "/home/${user}/Pictures/Screenshots";
    };

    programs.git = {
      enable = true;
      userEmail = "shieldscoen@gmail.com";
      userName = user;
    };

    nix.gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    gtk = {
      enable = true;

      theme = {
        package = utils.nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; };
        name = "${config.colorScheme.slug}";
      };
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.

  };
}
