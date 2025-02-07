{ pkgs, config, ... }:

let
  hyprlockConfig = pkgs.substituteAll {
    src = ../../../dots/hypr/hyprlock.conf;
    base00 = "${config.colorScheme.palette.base00}";
    base05 = "${config.colorScheme.palette.base05}";
    base0D = "${config.colorScheme.palette.base0D}";
    base03 = "${config.colorScheme.palette.base03}";
    font = "${config.font}";
  };
in
{
  programs.hyprlock.enable = true;
  xdg.configFile."hypr/hyprlock.conf".source = hyprlockConfig.out;
}
