{pkgs, config, ...}:

let
  hyprConfig = pkgs.substituteAll {
    src = ../../../dots/hypr/hyprland.conf;
    base08 = "${config.colorScheme.colors.base08}";
    base03 = "${config.colorScheme.colors.base03}";
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
    extraConfig = builtins.readFile hyprConfig.out;   
  };
}