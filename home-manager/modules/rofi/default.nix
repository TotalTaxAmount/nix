{ pkgs, config, ... }:

let
  rofiTheme = pkgs.substituteAll {
    src = ../../../dots/rofi/systemTheme.rasi;
    base00 = "#${config.colorScheme.palette.base00}";
    base05 = "#${config.colorScheme.palette.base05}";
    base0D = "#${config.colorScheme.palette.base0D}";
  };
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      font = "${config.font} 12";
      fixed-num-lines = true;
      show-icons = true;
      icon-theme = "Candy Icons"; # Doesnt work idk why
      terminal = "${pkgs.alacritty}/bin/alacritty";

    };
    theme = "${rofiTheme.out}";
  };
}
