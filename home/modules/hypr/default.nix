{pkgs, config, ...}:

let
  hyprConfig = pkgs.substituteAll {
    src = ../../../dots/hypr/hyprland.conf;
    base0C = "${config.colorScheme.colors.base0C}";
    base03 = "${config.colorScheme.colors.base03}";
  };
in
{
  wayland.windowManager.hyprland = {
    extraConfig = builtins.readFile hyprConfig.out;   
  };

}
