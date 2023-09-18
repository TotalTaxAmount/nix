{ pkgs, config, ...}:

let
  rofiTheme = pkgs.substituteAll {
    src = ../../../dots/rofi/systemTheme.rasi;
    base00 = "#${config.colorScheme.colors.base00}";
    base05 = "#${config.colorScheme.colors.base05}";
    base0D = "#${config.colorScheme.colors.base0D}";
  };
in
{
  programs.rofi = {
    enable = true;
    extraConfig = {
      font = "Overpass Nerd Font Propo 15";
      fixed-num-lines = true;
      show-icons = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";

    };
    theme = "${rofiTheme.out}";
  };
}