{pkgs, config, ...}:

let
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
      src = ../../../../dots/alacritty/tmux/tmux.conf;
      base0D = "#${config.colorScheme.colors.base0D}";
   };
in {
  programs.tmux = {
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

   programs.zsh = {
      enable = true;
      shellAliases = {
         update = "/home/${user}/nix/build.sh";
         cat = "bat";
         shell = "/home/${user}/nix/shell.sh";
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
            name = "powerlevel10k-config";
            src = ./config;
            file = "p10k.zsh";
         }
   ];

	initExtraFirst = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme\nsource /home/${user}/.p10k.zsh";
   initExtra = ''
   POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
   ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#${config.colorScheme.colors.base0D}"
   '';

   oh-my-zsh = {
      enable = true;
	   custom = "/home/${user}/.config/zsh";
	   plugins = ["zsh-syntax-highlighting" "zsh-autosuggestions"];
	   extraConfig = '''';
     };
  };

  # OMZ Plugins
  xdg.configFile."zsh/plugins/zsh-autosuggestions".source = zsh-autosuggestions.out;
  xdg.configFile."zsh/plugins/zsh-syntax-highlighting".source = zsh-syntax-highlighting.out;
}