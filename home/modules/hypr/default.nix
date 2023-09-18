{pkgs, config, ...}:

let
  hyprConfig = pkgs.substituteAll {
    src = ../../../dots/hypr/hyprland.conf;
    base03 = "${config.colorScheme.colors.base03}";
    base05 = "${config.colorScheme.colors.base05}";
  };
in
{
  wayland.windowManager.hyprland = {
    extraConfig = builtins.readFile hyprConfig.out;   
  };

}
