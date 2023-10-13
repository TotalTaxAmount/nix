{ pkgs, config, ...}:

let
  # Fix werid script thing 
  scriptDir = builtins.dirOf ../../../dots/eww/scripts/battery; # I hate this
  configDir = pkgs.substituteAllFiles {
    src = ../../../dots/eww;
    files = [
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
    scriptdir = "${scriptDir}";  # TODO: Why do I have to do it this way??
  };
in
{
  programs.eww = {
    enable = true;
    configDir = configDir.out;
  };

  home.packages = with pkgs; [bc];
}