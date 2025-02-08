{
  pkgs,
  config,
  user,
  ...
}:

let
  # Tmux

  tmux-powerline = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-powerline";
    version = "v2.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "erikw";
      repo = "tmux-powerline";
      rev = "1b53117641fd42a16362e487414d70a51f9bf25e";
      sha256 = "sha256-ikZuryJl/i0sfmHkKXhffJi9rL4OC8UmfdGzp2uEKr0=";
    };
    rtpFilePath = "main.tmux";
  };

  # OMZ plugins
  zsh-autosuggestions = pkgs.fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-autosuggestions";
    rev = "c3d4e576c9c86eac62884bd47c01f6faed043fc5";
    hash = "sha256-B+Kz3B7d97CM/3ztpQyVkE6EfMipVF8Y4HJNfSRXHtU=";
  };

  zsh-syntax-highlighting = pkgs.fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-syntax-highlighting";
    rev = "143b25eb98aa3227af63bd7f04413e1b3e7888ec";
    hash = "sha256-TKGCck51qQ50dQGntKaeSk8waK3BlwUjueg4MImTH8k=";
  };

  tmuxConfig = pkgs.substituteAll {
    src = ./tmux.conf;
    base0D = "#${config.colorScheme.palette.base0D}";
  };
in
{
  programs = {
    tmux = {
      enable = true;

      baseIndex = 1;
      prefix = "C-Space";
      mouse = true;
      keyMode = "vi";

      plugins = with pkgs; [
        tmux-powerline
        tmuxPlugins.better-mouse-mode
        tmuxPlugins.power-theme
        tmuxPlugins.net-speed
      ];

      extraConfig = builtins.readFile tmuxConfig.out;
    };

    zsh = {
      enable = true;
      shellAliases = {
        update = "/home/${user}/nix/build.sh"; # TODO: Nixify
        cat = "bat";
        open = "stupidAlias";
        ls = "exa -l --icons";
        neofetch = "fastfetch";
      };
      enableCompletion = true;

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];

      initExtra = ''
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#${config.colorScheme.palette.base0D}"

        stupidAlias() {
           xdg-open $1
        } 
      ''; # Hacky fix for syntax highlighting

      oh-my-zsh = {
        enable = true;
        custom = "/home/${user}/.config/zsh";
        plugins = [
          "zsh-syntax-highlighting"
          "zsh-autosuggestions"
        ];
        extraConfig = "";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    starship = {
      # TODO: use system theme
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = ''$all'';
        add_newline = false;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✕](bold red)";
        };
      };
    };

  };

  # OMZ Plugins
  xdg.configFile."zsh/plugins/zsh-autosuggestions".source = zsh-autosuggestions.out;
  xdg.configFile."zsh/plugins/zsh-syntax-highlighting".source = zsh-syntax-highlighting.out;
}
