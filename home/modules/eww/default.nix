{ pkgs, config, ...}:

let
  configDir = pkgs.substituteAll {
    src = "../../../dots/eww/";
    base00 = "#${config.colorScheme.colors.base00}";
    base03 = "#${config.colorScheme.colors.base03}";
    base08 = "#${config.colorScheme.colors.base08}";
  }
in
{
  programs.eww = {
    enable = true;
    configDir = configDir.out;
  };
}