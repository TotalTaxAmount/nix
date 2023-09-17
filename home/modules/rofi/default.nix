{ pkgs, config, ...}:

let
  rofiTheme = pkgs.substituteAll {
    src = ../../../dots/rofi/theme.rasi;
    base08 = "${config.colorScheme.colors.base08}";
    base03 = "${config.colorScheme.colors.base03}";
  };
in
{
  programs.rofi = {
    enable = true;
    extraConfig = builtins.readFile ../../../dots/rofi/config.rasi;
    theme = rofiTheme.out;
  };
}