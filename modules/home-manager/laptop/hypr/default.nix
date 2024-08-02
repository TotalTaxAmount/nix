{
  pkgs,
  config,
  user,
  ...
}:

let
  hyprConfig = pkgs.substituteAll {
    src = ../../../../dots/hypr/hyprland.conf;
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
