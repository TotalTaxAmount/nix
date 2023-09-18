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
      # TODO: Replace all these colors also...
      colors.primary.background = "#1B1E24";
      colors.primary.foreground = "#E1E6F0";
      colors.primary.dim_foreground = "#B0B6C1";
      colors.cursor.text = "#1B1E24";
      colors.cursor.cursor = "#E1E6F0";
      colors.vi_mode_cursor.text = "#1B1E24";
      colors.vi_mode_cursor.cursor = "#E1E6F0";
      colors.selection.text = "CellForeground";
      colors.selection.background = "#2B2F3B";
      colors.search.matches.background = "CellBackground";
      colors.search.matches.foreground = "#E1E6F0";
      colors.search.footer_bar.background = "#20252F";
      colors.search.footer_bar.foreground = "#E1E6F0";

      colors.normal.black = "#272C36";
      colors.normal.red = "#BF616A";
      colors.normal.green = "#A3BE8C";
      colors.normal.yellow = "#EBCB8B";
      colors.normal.blue = "#81A1C1";
      colors.normal.magenta = "#B48EAD";
      colors.normal.cyan = "#88C0D0";
      colors.normal.white = "#E5E9F0";

      colors.bright.black = "#3B4252";
      colors.bright.red = "#BF616A";
      colors.bright.green = "#A3BE8C";
      colors.bright.yellow = "#EBCB8B";
      colors.bright.blue = "#81A1C1";
      colors.bright.magenta = "#B48EAD";
      colors.bright.cyan = "#8FBCBB";
      colors.bright.white = "#ECEFF4";

      colors.dim.black = "#1D2129";
      colors.dim.red = "#94545D";
      colors.dim.green = "#809575";
      colors.dim.yellow = "#B29E75";
      colors.dim.blue = "#68809A";
      colors.dim.magenta = "#8C738C";
      colors.dim.cyan = "#6D96A5";
      colors.dim.white = "#AEB3BB";   
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
	'';

   oh-my-zsh = {
      enable = true;
	   custom = "/home/${user}/.config/zsh";
	   plugins = ["zsh-syntax-highlighting" "zsh-autosuggestions"];
	   extraConfig = '''';
     };
  };
}