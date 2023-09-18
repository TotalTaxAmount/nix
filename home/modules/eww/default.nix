{ pkgs, config, ...}:

let
  # Fix werid script thing
  scriptDir = builtins.dirOf ../../../dots/eww/scripts/battery;
  configDir = pkgs.substituteAllFiles {
    src = ../../../dots/eww;
    files = [
      "eww.scss"
      "eww.yuck"
      "nixos-icon.svg"
    ];
    base01 = "#${config.colorScheme.colors.base01}";
    base03 = "#${config.colorScheme.colors.base03}";
    base04 = "#${config.colorScheme.colors.base04}";
    base08 = "#${config.colorScheme.colors.base08}";
    base0D = "#${config.colorScheme.colors.base0D}";
    scriptdir = "${scriptDir}";
  };
in
{
  programs.eww = {
    enable = true;
    configDir = configDir.out;
  };
}