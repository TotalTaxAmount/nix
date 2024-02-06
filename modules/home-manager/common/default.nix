{ config, pkgs, inputs, user, ... }:

let 
  customThemes = import ../../theme/custom.nix;
  base16Themes = inputs.nix-colors.colorSchemes;

  # Flake stuff
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
  
in {
  imports = [
    ./btop
    ./nvim
    ./neofetch
    ./terminal
      
    inputs.nix-colors.homeManagerModule

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
    home.username = user;
    home.homeDirectory = "/home/${user}";

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
      jq
      bat
      wget
      eza
      (pkgs.callPackage ./shell { })

      #Customization
      nerdfonts

      # Langs and compilers
      python3   
    ];   

    programs.git = {
      enable = true;
      userEmail = "shieldscoen@gmail.com";
      userName = "TotalTaxAmount";
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