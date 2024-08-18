{
  pkgs,
  config,
  user,
  host,
  ...
}:

let
  baseConfig = builtins.readFile ../../../../dots/hypr/hyprland.conf;
  laptopExtra = builtins.readFile ../../../../dots/hypr/laptopExtra.conf;
  desktopExtra = builtins.readFile ../../../../dots/hypr/desktopExtra.conf;

  fullConfig = baseConfig + (if host == "desktop" then desktopExtra else if host == "laptop" then laptopExtra else "");

  hyprConfig = pkgs.substituteAll {
    src = fullConfig;
    base03 = "${config.colorScheme.palette.base03}";
    base0D = "${config.colorScheme.palette.base0D}";
    user = "${user}";
  };

in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # enableNvidiaPatches = true;
    extraConfig = builtins.readFile hyprConfig.out;
  };

}
