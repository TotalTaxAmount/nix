{pkgs, config, lib, user, ...}:
let
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
      src = ../../../dots/alacritty/tmux/tmux.conf;
      base0D = "#${config.colorScheme.colors.base0D}";
   };

in
{ 
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

   programs.alacritty = {
	  enable = true;	
     settings = {
      shell.program = "${pkgs.zsh}/bin/zsh";
      shell.args = ["-l" "-c" "tmux || tmux attach"];
      cursor.style = "Underline";
      colors.primary.background = "#${config.colorScheme.colors.base00}";
      colors.primary.foreground = "#${config.colorScheme.colors.base05}";
      colors.cursor.text = "#${config.colorScheme.colors.base00}";
      colors.cursor.cursor = "#${config.colorScheme.colors.base05}";
      colors.vi_mode_cursor.text = "#${config.colorScheme.colors.base00}";
      colors.vi_mode_cursor.cursor = "#${config.colorScheme.colors.base05}";
      colors.selection.text = "CellForeground";
      colors.search.matches.background = "CellBackground";
      colors.search.matches.foreground = "#${config.colorScheme.colors.base05}";
      colors.search.footer_bar.background = "#${config.colorScheme.colors.base00}";
      colors.search.footer_bar.foreground = "#${config.colorScheme.colors.base05}";

      colors.normal.black = "#${config.colorScheme.colors.base00}";
      colors.normal.red = "#${config.colorScheme.colors.base08}";
      colors.normal.green = "#${config.colorScheme.colors.base0B}";
      colors.normal.yellow = "#${config.colorScheme.colors.base0A}";
      colors.normal.blue = "#${config.colorScheme.colors.base0D}";
      colors.normal.magenta = "#${config.colorScheme.colors.base0E}";
      colors.normal.cyan = "#${config.colorScheme.colors.base0C}";
      colors.normal.white = "#${config.colorScheme.colors.base05}";

      colors.bright.black = "#${config.colorScheme.colors.base03}";
      colors.bright.red = "#${config.colorScheme.colors.base09}";
      colors.bright.green = "#${config.colorScheme.colors.base01}";
      colors.bright.yellow = "#${config.colorScheme.colors.base02}";
      colors.bright.blue = "#${config.colorScheme.colors.base04}";
      colors.bright.magenta = "#${config.colorScheme.colors.base06}";
      colors.bright.cyan = "#${config.colorScheme.colors.base0F}";
      colors.bright.white = "#${config.colorScheme.colors.base07}";

      font.normal = {
         family = "${config.font}";
         style = "Regular";
         size = "11";
      };
     };
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
   ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#${config.colorScheme.colors.base0D}"'';

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