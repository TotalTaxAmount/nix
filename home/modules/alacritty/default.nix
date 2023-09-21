{pkgs, config, lib, user, ...}:
let
   user="totaltaxamount";  # TODO: also fix this
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

      extraConfig = ''
      set-hook -g after-new-session "source-file ~/.config/tmux/tmux.conf"

      set -g @tmux_power_theme '#${config.colorScheme.colors.base05}'
      set -g history-limit 100000

      set -g @tmux_power_show_upload_speed true
      set -g @tmux_power_show_download_speed true
      set -g @tmux_power_date_format '%F'
      set -g @tmux_power_time_format '%T'

      set-window-option -g pane-base-index 1

      # Binds
      unbind n  #DEFAULT KEY
      unbind w  #DEFAULT KEY
      
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux.conf"
      
      bind v split-window -h -c "#{pane_current_path}"
      bind h split-window -v -c "#{pane_current_path}"

      bind -n C-a select-pane -L
      bind -n C-s select-pane -D
      bind -n C-w select-pane -U
      bind -n C-d select-pane -R

      bind -n M-s previous-window
      bind -n M-w next-window

      bind x kill-pane
      bind M-x kill-window

      bind n command-prompt "rename-window '%%'"
      bind w new-window -c "#{pane_current_path}"

      # Window nav
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9
      bind -n M-0 select-window -t 10


      '';
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
      };
     };
   };

   programs.zsh = {
      enable = true;
      shellAliases = {
         update = "/home/${user}/nix/build.sh";
         cat = "bat";
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
   ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#${config.colorScheme.colors.base03}"
	'';

   oh-my-zsh = {
      enable = true;
	   custom = "/home/${user}/.config/zsh";
	   plugins = ["zsh-syntax-highlighting" "zsh-autosuggestions"];
	   extraConfig = '''';
     };
  };
}