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

  # Configs:
  tmuxConfig = pkgs.substituteAll {
    src = ../../../../dots/zsh/tmux.conf;
    base0D = "#${config.colorScheme.colors.base0D}";
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
        update = "/home/${user}/nix/build.sh";
        cat = "bat";
        open = "stupidAlias";
        ls = "exa -l --icons";
      };
      enableCompletion = true;
      # history = {
      #    size = 10000;
      #    path = "${config.xdg.dataHome}/zsh/history";
      # };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
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
        # {
        #    name = "powerlevel10k-config";
        #    src = ./config.zsh;
        #    file = ".p10k.zsh";
        # }
      ];

      initExtraFirst = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source /home/${user}/.p10k.zsh'';
      initExtra = ''
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#${config.colorScheme.colors.base0D}"

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

  };

  # OMZ Plugins
  xdg.configFile."zsh/plugins/zsh-autosuggestions".source = zsh-autosuggestions.out;
  xdg.configFile."zsh/plugins/zsh-syntax-highlighting".source = zsh-syntax-highlighting.out;

  home.file.".p10k.zsh".source = ../../../../dots/zsh/.p10k.zsh;
}
