{pkgs, config, lib, user, ...}:
let
  
in
{ 
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
}