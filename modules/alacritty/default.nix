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
    cp -r ${../../../dots/alacritty}/* $out
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

        normal = {
          black = "#${config.colorScheme.palette.base00}";
          red = "#${config.colorScheme.palette.base0A}";
          green = "#${config.colorScheme.palette.base0B}";
          yellow = "#${config.colorScheme.palette.base09}";
          blue = "#${config.colorScheme.palette.base0D}";
          magenta = "#${config.colorScheme.palette.base0E}";
          cyan = "#${config.colorScheme.palette.base0C}";
          white = "#${config.colorScheme.palette.base05}";
        };

        bright = {
          black = "#${config.colorScheme.palette.base03}";
          red = "#${config.colorScheme.palette.base09}";
          green = "#${config.colorScheme.palette.base01}";
          yellow = "#${config.colorScheme.palette.base02}";
          blue = "#${config.colorScheme.palette.base04}";
          magenta = "#${config.colorScheme.palette.base06}";
          cyan = "#${config.colorScheme.palette.base0F}";
          white = "#${config.colorScheme.palette.base07}";
        };
      };

      window.opacity = 1;

      font.normal = {
        family = "${config.font}";
        style = "Regular";
      };
    };
  };
}
