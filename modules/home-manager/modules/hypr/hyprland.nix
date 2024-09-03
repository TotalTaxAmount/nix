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
  backgrounds = pkgs.writeScriptBin "backgrounds" ''
    #!${pkgs.bash}/bin/bash
    export SWWW_TRANSITION_FPS=60
    export SWWW_TRANSITION_STEP=2

    INTERVAL=60
    ${pkgs.swww}/bin/swww-daemon

    case "${host}" in
      "laptop")
        while true; do
          find "/home/${user}/nix/dots/swww/wallpapers/" \
            | while read -r img; do
              echo "$((RANDOM % 1000)):$img"
            done \
            | sort -n | cut -d':' -f2- \
            | while read -r img; do
              ${pkgs.dunst}/bin/dunstify "Background Changed" "New background: $img"
              ${pkgs.swww}/bin/swww img --transition-type=center "$img"
              sleep $INTERVAL
            done
        done
        ;;
        
      "desktop")
        swww img -o DP-1 "/home/${user}/nix/dots/swww/desktop/ultrawide.png"
        swww img -o HDMI-A-1 "/home/${user}/nix/dots/swww/desktop/2nd.jpg"
        ;;
        
      *)
        exit 1
        ;;
    esac
  '';

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
    backgrounds = "${backgrounds}/bin/backgrounds";
  };
in
{
  home.packages = with pkgs; [
    wlr-randr
    backgrounds
    hyprland-activewindow
  ];

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   # x11.enable = true;
  #   package = config.cursor.package;
  #   name = config.cursor.name;
  #   size = config.cursor.size;
  # };

  wayland.windowManager.hyprland = {
    enable = true;
    # enableNvidiaPatches = true;
    extraConfig = builtins.readFile hyprConfig.out;
    package = inputs.hyprland.packages.${system}.hyprland;
    plugins = [
        inputs.hyprsplit.packages.${system}.hyprsplit
    ];


  #   settings = {
  #     exec-once = [
  #       "${backgrounds}/bin/backgrounds"
  #       "${pkgs.copyq}"
  #       "sleep 2 && ${inputs.hyprland.packages.${system}.hyprland}/bin/hyprctl setcursor ${config.cursor.name} ${config.cursor.size}"
  #     ];

  #     input = {
  #       kb_layout = "us";
  #       # kb_variant =
  #       # kb_model =
  #       # kb_options =
  #       # kb_rules =

  #       follow_mouse = 1;

  #       touchpad = {
  #           natural_scroll = "no";
  #           clickfinger_behavior = "yes";
  #           tap-to-click = "no";
  #           disable_while_typing = "no";
  #       };

  #       sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
  #     };

  #     general = {
  #       gaps_in = 5;
  #       gaps_out = 10;
  #       border_size = 2;
  #       col.active_border = "rgb(${config.colorScheme.palette.base0D})";
  #       col.inactive_border = "rgb(${config.colorScheme.palette.base03})";

  #       layout = "dwindle";
  #     };

  #     decoration = {
  #       rounding = 10;
  #       drop_shadow = "yes";
  #       shadow_range = 10;
  #       shadow_render_power = 3;
  #       col.shadow = "rgb(${config.colorScheme.palette.base0D})";
  #       col.shadow_inactive = "rgb(${config.colorScheme.palette.base03})";
  #     };
  #   };
  };
}
