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
    ./nvim
      
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
    # System theme
    # Use custom themes customThemes.[theme] (defined in themes/custom.nix) or inputs.nix-colors.colorSchemes.[theme] themes list at https://github.com/tinted-theming/base16-schemes
    colorScheme = base16Themes.twilight;
    font = "FiraCode Nerd Font";

    home.username = user;
    home.homeDirectory = "/home/${user}";

    # Unfree stuff/Insecure
    nixpkgs.config.allowUnfree = true;

    
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

      #Terminal Apps/Config
      zsh-powerlevel10k
      neofetch
      file
      tree

      #Utils
      jq
      bat
      wget

      #Customization
      nerdfonts

      # Langs and compilers
      python3      

    programs.git = {
      enable = true;
      userEmail = "shieldscoen@gmail.com";
      userName = "TotalTaxAmount";
    };


    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}