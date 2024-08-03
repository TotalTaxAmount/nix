{
  pkgs,
  config,
  lib,
  user,
  ...
}:
let

in
{
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.zsh}/bin/zsh";
      shell.args = [
        "-l"
        "-c"
        "tmux new-session || tmux"
      ];
      cursor.style = "Underline";
      colors.primary.background = "#${config.colorScheme.palette.base00}";
      colors.primary.foreground = "#${config.colorScheme.palette.base05}";
      colors.cursor.text = "#${config.colorScheme.palette.base00}";
      colors.cursor.cursor = "#${config.colorScheme.palette.base05}";
      colors.vi_mode_cursor.text = "#${config.colorScheme.palette.base00}";
      colors.vi_mode_cursor.cursor = "#${config.colorScheme.palette.base05}";
      colors.selection.text = "CellForeground";
      colors.search.matches.background = "CellBackground";
      colors.search.matches.foreground = "#${config.colorScheme.palette.base05}";

      colors.normal.black = "#${config.colorScheme.palette.base00}";
      colors.normal.red = "#${config.colorScheme.palette.base0A}";
      colors.normal.green = "#${config.colorScheme.palette.base0B}";
      colors.normal.yellow = "#${config.colorScheme.palette.base09}";
      colors.normal.blue = "#${config.colorScheme.palette.base0D}";
      colors.normal.magenta = "#${config.colorScheme.palette.base0E}";
      colors.normal.cyan = "#${config.colorScheme.palette.base0C}";
      colors.normal.white = "#${config.colorScheme.palette.base05}";

      colors.bright.black = "#${config.colorScheme.palette.base03}";
      colors.bright.red = "#${config.colorScheme.palette.base09}";
      colors.bright.green = "#${config.colorScheme.palette.base01}";
      colors.bright.yellow = "#${config.colorScheme.palette.base02}";
      colors.bright.blue = "#${config.colorScheme.palette.base04}";
      colors.bright.magenta = "#${config.colorScheme.palette.base06}";
      colors.bright.cyan = "#${config.colorScheme.palette.base0F}";
      colors.bright.white = "#${config.colorScheme.palette.base07}";

      window.opacity = 1;

      font.normal = {
        family = "${config.font}";
        style = "Regular";
      };
    };
  };
}
