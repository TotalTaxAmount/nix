{pkgs, config, ...}:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
    extraConfig = builtins.readFile ../../dots/hypr/hyprland.conf;
      
  };
}