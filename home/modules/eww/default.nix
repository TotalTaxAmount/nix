{ pkgs, config, ...}:

let
  # Fix werid script thing
  scriptDir = builtins.dirOf ../../../dots/eww/scripts/battery;
  configDir = pkgs.substituteAllFiles {
    src = ../../../dots/eww;
    files = [
      "scripts/battery.sh"
      "scripts/currentapp.sh"
      "scripts/music.sh"
      "scripts/pop.sh"
      "scripts/sys_info.sh"
      "scripts/workspaces.sh"
      
      "modules/info.yuck"
      "modules/system.yuck"
      "modules/main.yuck"

      "eww.scss"
      "eww.yuck"
      "nixos-icon.svg"
    ];
    base00 = "#${config.colorScheme.colors.base00}";
    base03 = "#${config.colorScheme.colors.base03}";
    base05 = "#${config.colorScheme.colors.base05}";
    base08 = "#${config.colorScheme.colors.base08}";
    base0C = "#${config.colorScheme.colors.base0C}";
    base0D = "#${config.colorScheme.colors.base0D}";
    font = "${config.font}";
  };
in
{
  programs.eww = {
    enable = true;
    configDir = configDir.out;
  };
}