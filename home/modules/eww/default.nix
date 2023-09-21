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
    base00 = "#${config.colorScheme.colors.base00}";
    base03 = "#${config.colorScheme.colors.base03}";
    base05 = "#${config.colorScheme.colors.base05}";
    base08 = "#${config.colorScheme.colors.base08}";
    base0D = "#${config.colorScheme.colors.base0D}";
    font = "${config.font}";
    scriptdir = "${scriptDir}";
  };
in
{
  programs.eww = {
    enable = true;
    configDir = configDir.out;
  };
}