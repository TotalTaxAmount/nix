{ pkgs, config, ...}:

let
  scriptDir = builtins.dirOf ../../../dots/eww/scripts/battery;
  configDir = pkgs.substituteAllFiles {
    src = ../../../dots/eww;
    files = [
      "eww.scss"
      "eww.yuck"
      "nixos-icon.svg"

    ];
    base00 = "#${config.colorScheme.colors.base00}";
    base03 = "#${config.colorScheme.colors.base03}";
    base08 = "#${config.colorScheme.colors.base08}";
    scriptdir = "${scriptDir}";
  };
in
{
  programs.eww = {
    enable = true;
    configDir = configDir.out;
  };
}