{pkgs, config, ...}:

let
  hyprConfig = pkgs.substituteAll {
    src = ../../../dots/hypr/hyprland.conf;
    base03 = "${config.colorScheme.colors.base03}";
    base0D = "${config.colorScheme.colors.base0D}";
  };
in
{
  wayland.windowManager.hyprland = {
    extraConfig = builtins.readFile hyprConfig.out;   
  };

}
