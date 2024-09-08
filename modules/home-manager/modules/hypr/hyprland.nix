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
        WALLPAPER_DIR="/home/${user}/nix/dots/swww/wallpapers"

        # Create an array of all the wallpaper image files
        IMAGE_FILES=($WALLPAPER_DIR/*.jpg)

        # Infinite loop to rotate through images
        while true; do
          # Shuffle the array of image files
          SHUFFLED_FILES=($(shuf -e "$IMAGE_FILES[@]"))

          # Iterate through the shuffled array
          for IMAGE in "$SHUFFLED_FILES[@]"; do
            ${pkgs.swww} img -o eDP-1 "$IMAGE"
            sleep "$INTERVAL"
          done
        done
        ;;
        
      "desktop")
        ${pkgs.swww} img -o DP-1 "/home/${user}/nix/dots/swww/desktop/ultrawide.png"
        ${pkgs.swww} img -o HDMI-A-1 "/home/${user}/nix/dots/swww/desktop/2nd.jpg"
        ;;
        
      *)
        exit 1
        ;;
    esac
  '';

  baseConfig = builtins.readFile ../../../../dots/hypr/hyprland/hyprland.conf;
  laptopExtra = builtins.readFile ../../../../dots/hypr/hyprland/laptopExtra.conf;
  laptopStrixExtra = builtins.readFile ../../../../dots/hypr/hyprland/laptopStrixExtra.conf;
  desktopExtra = builtins.readFile ../../../../dots/hypr/hyprland/desktopExtra.conf;


  fullConfig = pkgs.writeText "hyprFullConfig.conf" (
    baseConfig
    + (if host == "laptop" then laptopExtra else "")
    + (if host == "desktop" then desktopExtra else "")
    + (if host == "laptop-strix" then laptopStrixExtra else "")
  );

  hyprConfig = pkgs.substituteAll {
    src = fullConfig;
    base03 = "${config.colorScheme.palette.base03}";
    base0D = "${config.colorScheme.palette.base0D}";
    user = "${user}";
    backgrounds = "${backgrounds}/bin/backgrounds";
    cursorSize = config.cursor.size;
    cursorTheme = config.cursor.name;
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

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
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
