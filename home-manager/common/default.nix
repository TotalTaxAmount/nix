{
  config,
  pkgs,
  inputs,
  user,
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

in
{
  imports = [
    ../../modules/btop
    ../../modules/nvim
    ../../modules/terminal

    inputs.nix-colors.homeManagerModule

  ];

  options = {
    font = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      example = "Noto Fonts";
      description = "\n        Name of system font (make sure its installed)\n      ";
    };

    cursor = lib.mkOption {
      default = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };
      description = ''
        Configuration for the cursor theme.
        - `name` specifies the cursor theme to use.
        - `package` specifies the package that contains the cursor theme.
        - `size` specifies the size of the cursor.
      '';
    };
  };

  config = {
    # Unfree stuff
    nixpkgs.config.allowUnfree = true;

    home = {
      username = user;
      homeDirectory = "/home/${user}";

      sessionVariables = {
        XDG_SCREENSHOTS_DIR = "/home/${user}/Pictures/Screenshots";
        HYPRCURSOR_THEME = config.cursor.name;
        HYPRCURSOR_SIZE = config.cursor.size;
        XCURSOR_SIZE = config.cursor.size;
        XCURSOR_THEME = config.cursor.name;
        XDG_DATA_HOME = "/home/${user}/.local/share";
        XDG_SCREENREC_DIR = "/home/${user}/Vidoes/Screenrecordings";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        ZSH_TMUX_AUTOSTART = "true";
        TERMINAL = "${pkgs.alacritty}";
      };
    };

    home.packages = with pkgs; [
      # Customization
      zsh-powerlevel10k

      #Utils
      nixd
      jq
      bat
      wget
      eza
      python3
      tree
      zip
      unzip
      file
      fastfetch
    ];

    programs = {
      git = {
        enable = true;
        package = pkgs.gitFull;

        settings = {
          pull.rebase = false;
          user.signingkey = "718CE018D826D164";
          commit.gpgsign = true;
          core.editor = "${pkgs.zed-editor}/bin/zeditor --wait";
          http.curlOptions = "-4";
          credential.helper = "libsecret";
          user = {
            email = "shieldscoen@gmail.com";
            name = user;
          };

        };
      };

      gpg = {
        enable = true;
        settings = {
          keyserver = "keys.openpgp.org";
        };
      };

      home-manager.enable = true;
    };

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };

    nix.gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    gtk = {
      enable = true;

      theme = {
        package = lib.mkDefault (utils.nix-colors-lib.gtkThemeFromScheme { scheme = config.colorScheme; });
        name = lib.mkDefault "${config.colorScheme.slug}";
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      name = config.cursor.name;
      package = config.cursor.package;
      size = config.cursor.size;
    };

    home.stateVersion = "25.05"; # Dont change unless changelog says so

  };
}
