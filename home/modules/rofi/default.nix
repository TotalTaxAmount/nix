{ pkgs, config, ...}:

let
  rofiTheme = pkgs.substituteAll {
    src = ../../../dots/rofi/systemTheme.rasi;
    base08 = "${config.colorScheme.colors.base08}";
    base03 = "${config.colorScheme.colors.base03}";
  };
in
{
  programs.rofi = {
    enable = true;
    extraConfig = {
      font = "Overpass Nerd Font Propo 15";
      fixed-num-lines = true;
      show-icons = true;
      terminal = "alacritty";

    };
    theme = "${rofiTheme.out}";
  };
}