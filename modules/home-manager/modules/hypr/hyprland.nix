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
    #!${pkgs.python3}/bin/python3

    import os
    import subprocess
    import time
    import random
    from pathlib import Path

    os.environ['SWWW_TRANSITION_FPS'] = '60'
    os.environ['SWWW_TRANSITION_STEP'] = '2'
    os.environ['SWWW_TRANSITION'] = 'center'
    interval = 60

    time.sleep(2) 
    subprocess.Popen([f'${pkgs.swww}/bin/swww-daemon'], close_fds=True)
    time.sleep(2)

    def set_wallpaper_image(path, output=None):
        cmd = [f'${pkgs.swww}/bin/swww', 'img']
        if output:
            cmd += ['-o', output]
        cmd.append(path)
        subprocess.run(cmd)

    if "${host}" in ["laptop", "laptop-strix"]:
        wallpaper_dir = Path(f'/home/${user}/nix/dots/swww/wallpapers')
        image_files = list(wallpaper_dir.glob('*.jpg'))

        while True:
            shuffled_files = random.sample(image_files, len(image_files))
            for path in shuffled_files:
                print(f"switch: {path}")
                set_wallpaper_image(path)
                time.sleep(interval)

    elif "${host}" == "desktop":
        set_wallpaper_image(f'/home/${user}/nix/dots/swww/desktop/ultrawide.png', 'DP-1')
        set_wallpaper_image(f'/home/${user}/nix/dots/swww/desktop/2nd.jpg', 'HDMI-A-1')

    else:
        exit(1)
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
