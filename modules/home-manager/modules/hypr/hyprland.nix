{
  pkgs,
  config,
  user,
  host,
  inputs,
  system,
  ...
}:

let
  baseConfig = builtins.readFile ../../../../dots/hypr/hyprland/hyprland.conf;
  laptopExtra = builtins.readFile ../../../../dots/hypr/hyprland/laptopExtra.conf;                                                                               
  desktopExtra = builtins.readFile ../../../../dots/hypr/hyprland/desktopExtra.conf;

  fullConfig = pkgs.writeText "hyprFullConfig.conf" (
    baseConfig
    + (if host == "laptop" then laptopExtra else "")
    + (if host == "desktop" then desktopExtra else "")
  );

  hyprConfig = pkgs.substituteAll {
    src = fullConfig;
    base03 = "${config.colorScheme.palette.base03}";
    base0D = "${config.colorScheme.palette.base0D}";
    user = "${user}";
  };

in
{
  home.packages = with pkgs; [
    wlr-randr
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    # enableNvidiaPatches = true;
    extraConfig = builtins.readFile hyprConfig.out;
    package = inputs.hyprland.packages.${system}.hyprland;
    plugins = [
       inputs.hyprsplit.packages.${system}.hyprsplit
    ];
  };
}
