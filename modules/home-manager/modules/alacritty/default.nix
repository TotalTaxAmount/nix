{
  pkgs,
  config,
  lib,
  user,
  ...
}:
let
  scripts = pkgs.runCommand "fix-scripts" { } ''
    mkdir -p $out
    cp -r ${../../../../dots/alacritty}/* $out
    chmod +x $out/*.sh
  '';
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [
          "-l"
          "-c"
          "${scripts.out}/tmux-attach.sh || tmux"
        ];
      };
      cursor.style = "Underline";
      colors = {
        primary.background = "#${config.colorScheme.palette.base00}";
        primary.foreground = "#${config.colorScheme.palette.base05}";
        cursor.text = "#${config.colorScheme.palette.base00}";
        cursor.cursor = "#${config.colorScheme.palette.base05}";
        vi_mode_cursor.text = "#${config.colorScheme.palette.base00}";
        vi_mode_cursor.cursor = "#${config.colorScheme.palette.base05}";
        selection.text = "CellForeground";
        search.matches.background = "CellBackground";
        search.matches.foreground = "#${config.colorScheme.palette.base05}";

        normal.black = "#${config.colorScheme.palette.base00}";
        normal.red = "#${config.colorScheme.palette.base0A}";
        normal.green = "#${config.colorScheme.palette.base0B}";
        normal.yellow = "#${config.colorScheme.palette.base09}";
        normal.blue = "#${config.colorScheme.palette.base0D}";
        normal.magenta = "#${config.colorScheme.palette.base0E}";
        normal.cyan = "#${config.colorScheme.palette.base0C}";
        normal.white = "#${config.colorScheme.palette.base05}";

        bright.black = "#${config.colorScheme.palette.base03}";
        bright.red = "#${config.colorScheme.palette.base09}";
        bright.green = "#${config.colorScheme.palette.base01}";
        bright.yellow = "#${config.colorScheme.palette.base02}";
        bright.blue = "#${config.colorScheme.palette.base04}";
        bright.magenta = "#${config.colorScheme.palette.base06}";
        bright.cyan = "#${config.colorScheme.palette.base0F}";
        bright.white = "#${config.colorScheme.palette.base07}";
      };

      window.opacity = 1;

      font.normal = {
        family = "${config.font}";
        style = "Regular";
      };
    };
  };
}
