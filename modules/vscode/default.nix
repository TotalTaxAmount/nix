{ pkgs, config, ... }:

let
  customcss = pkgs.replaceVarsWith {
    src = ./customcss.css;
    replacements = {
      focusColor = "#${config.colorScheme.palette.base05}";
    };
    name = "customcss";
  };

  settings = pkgs.replaceVarsWith {
    src = ./settings.json;
    replacements = {
      font = config.font;
      customcss = customcss.out;
      # jdk17 = pkgs.openjdk17;
      jdk21 = pkgs.openjdk21;
    };
    name = "settings";
  };

in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions =
      with pkgs.vscode-extensions;
      [
        rust-lang.rust-analyzer
        ms-vscode.cpptools
        ms-vscode-remote.remote-ssh
        jnoortheen.nix-ide
        ms-vscode.makefile-tools
        esbenp.prettier-vscode
        eamodio.gitlens
        vscode-icons-team.vscode-icons
        alefragnani.bookmarks
        pkief.material-icon-theme
        editorconfig.editorconfig
        tamasfe.even-better-toml
        vue.volar
        svelte.svelte-vscode
        platformio.platformio-vscode-ide
        redhat.java
        vscjava.vscode-java-test
        vscjava.vscode-java-debug
        vscjava.vscode-gradle
      ]
      ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "onedark";
          publisher = "bartoszmaka95";
          version = "0.2.1";
          sha256 = "sha256-j03kdtx9CqypUsBGk04mtvTvPf5Uy36c+wnJaOGFaNU=";
        }
        {
          name = "vscode-direnv";
          publisher = "Rubymaniac";
          version = "0.0.2";
          sha256 = "sha256-TVvjKdKXeExpnyUh+fDPl+eSdlQzh7lt8xSfw1YgtL4=";
        }
        {
          name = "asm-code-lens";
          publisher = "maziac";
          version = "2.6.0";
          sha256 = "sha256-4p3kizvEqqsMNJOhyKxJQ0rH3ePjstKLWb22BYy3yZk=";
        }
        {
          name = "vsc-material-theme-but-i-wont-sue-you";
          publisher = "t3dotgg";
          version = "34.5.0";
          sha256 = "sha256-i42M245/gh6hzU3h/WiTUVE/+BTS0WmscUDl42u0OI4=";
        }
        {
          name = "indenticator";
          publisher = "sirtori";
          version = "0.7.0";
          sha256 = "sha256-J5iNO6V5US+GFyNjNNA5u9H2pKPozWKjQWcLAhl+BjY=";
        }
        {
          name = "vscode-proto3";
          publisher = "zxh404";
          version = "0.5.5";
          sha256 = "sha256-Em+w3FyJLXrpVAe9N7zsHRoMcpvl+psmG1new7nA8iE=";
        }
      ]);
  };

  xdg.configFile."Code/User/settings.json".source = settings.out;
  xdg.configFile."Code/User/keybindings.json".source = ./keybinds.json;
}
