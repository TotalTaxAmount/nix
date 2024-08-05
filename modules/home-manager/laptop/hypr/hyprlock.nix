{ pkgs, config, ... }:

let
  hyprlockConfig = pkgs.substituteAll {
    src = ../../../../dots/hypr/hyprlock.conf;
    base00 = "${config.colorScheme.palette.base00}";
    base05 = "${config.colorScheme.palette.base05}";
    base08 = "${config.colorScheme.palette.base08}";
    font = "${config.font}";
  };
in
{
  programs.hyprlock.enable = true;
  xdg.configFile."hypr/hyprlock.conf".source = hyprlockConfig.out;
}
