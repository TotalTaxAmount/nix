{pkgs, config, ...}:

let
  hyprConfig = pkgs.substituteAll {
    src = ../../../dots/hypr/hyprland.conf;
    base08 = "${config.colorScheme.colors.base08}";
    base03 = "${config.colorScheme.colors.base03}";

    # programs
    alacritty = "${pkgs.alacritty}";
    brave = "${pkgs.brave}";
    rofi = "${pkgs.rofi}";
    eww = "${pkgs.ewww}";
    openrgb = "${pkgs.openrgb}";
  };
in
{
  wayland.windowManager.hyprland = {
    extraConfig = builtins.readFile hyprConfig.out;   
  };

}
