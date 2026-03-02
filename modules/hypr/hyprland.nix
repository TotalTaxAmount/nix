{
  pkgs,
  config,
  user,
  host,
  inputs,
  system,
  lib,
  ...
}:

let
  backgrounds-dir = pkgs.stdenvNoCC.mkDerivation {
    name = "background-dir";

    src = ./backgrounds;

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/
      cp -r ${./backgrounds/.} $out/share/backgrounds/
    '';
  };

  # TODO: Make this better
  backgrounds =
    let
      script = ''
        #!${pkgs.python314}/bin/python3

        import os
        import subprocess
        import time
        import random
        from pathlib import Path

        os.environ['SWWW_TRANSITION_FPS'] = '60'
        os.environ['SWWW_TRANSITION_STEP'] = '2'
        os.environ['SWWW_TRANSITION'] = 'center'
        interval = 60

        def set_wallpaper_image_swww(path, output=None):
            cmd = [f'${pkgs.swww}/bin/swww', 'img']
            if output:
                cmd += ['-o', output]
            cmd.append(path)
            subprocess.run(cmd)

      ''
      + (
        if host == "laptop" then
          ''
            time.sleep(2) 
            subprocess.Popen([f'${pkgs.swww}/bin/swww-daemon'], close_fds=True)
            time.sleep(2)
            wallpaper_dir = Path(f'${backgrounds-dir}/share/backgrounds/laptop')
            image_files = list(wallpaper_dir.glob('*.jpg'))

            while True:
                shuffled_files = random.sample(image_files, len(image_files))
                for path in shuffled_files:
                    print(f"switch: {path}")
                    set_wallpaper_image_swww(path)
                    time.sleep(interval)
          ''
        else if host == "desktop" then
          ''
            # TODO: Enable when swww works on 2nd monitor
            subprocess.Popen([f'${pkgs.hyprpaper}/bin/hyprpaper'], close_fds=True)
            # set_wallpaper_image_swww(f'${backgrounds-dir}/share/backgrounds/desktop/ultrawide.png', 'DP-1')
            # set_wallpaper_image_swww(f'${backgrounds-dir}/share/backgrounds/desktop/2nd.jpg', 'HDMI-A-1')
          ''
        else
          ''
            print("No background for ${host}")
            exit(1)
          ''
      );
    in
    pkgs.writeScriptBin "backgrounds" script;

  audioSwitcher = pkgs.writeScriptBin "audioSwitcher" ''
    #!${pkgs.python314}/bin/python
    import sys
    import subprocess
    import re

    """
    WirePlumber switcher using node.description for clean Rofi menus.
    """

    def get_nodes(target_class):
        # Get status to find all numeric IDs present in the graph
        proc = subprocess.run(["${pkgs.wireplumber}/bin/wpctl", "status"], capture_output=True, text=True)
        
        # Matches lines like "  74. Some Device Name" or "* 63. Internal Audio"
        potential_ids = re.findall(r"(\*?)\s+(\d+)\.", proc.stdout)
        
        valid_nodes = []
        seen_ids = set()

        for is_default, node_id in potential_ids:
            if node_id in seen_ids:
                continue
            seen_ids.add(node_id)

            # Inspect each node to verify class and get the friendly description
            inspect = subprocess.run(["${pkgs.wireplumber}/bin/wpctl", "inspect", node_id], capture_output=True, text=True)
            
            # 1. Verify this is the correct media class (e.g., Audio/Sink)
            if f'media.class = "{target_class}"' in inspect.stdout:
                
                # 2. Extract node.description using regex
                # Example: node.description = "Coen Shields' Pixel Buds Pro"
                desc_match = re.search(r'node.description = "(.*)"', inspect.stdout)
                friendly_name = desc_match.group(1) if desc_match else f"Unknown Device ({node_id})"
                
                display = f"{node_id}. {friendly_name}"
                if "*" in is_default:
                    display = f"<b>{display} *</b>"
                
                valid_nodes.append(display)
        
        return valid_nodes

    def main():
        if len(sys.argv) != 2:
            print("Usage: audioSwitcher <Sinks|Sources>")
            sys.exit(1)

        category = sys.argv[1]
        target_class = "Audio/Sink" if category == "Sinks" else "Audio/Source"
        
        nodes = get_nodes(target_class)
        
        if not nodes:
            print(f"No valid {category} found.")
            sys.exit(1)

        # Show Rofi menu
        rofi = subprocess.run(
            ["${pkgs.rofi}/bin/rofi", "-dmenu", "-markup-rows", "-p", f"Select {category[:-1]}"],
            input="\n".join(nodes),
            text=True,
            capture_output=True
        )

        if rofi.returncode == 0 and rofi.stdout.strip():
            # Strip <b> tags for ID extraction
            clean_selection = re.sub(r"<[^>]*>", "", rofi.stdout.strip())
            # Split by the first "." to get the ID
            node_id = clean_selection.split(".")[0].strip()
            subprocess.run(["${pkgs.wireplumber}/bin/wpctl", "set-default", node_id])

    if __name__ == "__main__":
        main()
  '';

  screen-rec = pkgs.writeScriptBin "screen-rec" ''
    if pgrep -x "wl-screenrec" > /dev/null; then
      killall -s 2 wl-screenrec
      exit 0
    fi

    FILE="$XDG_SCREENREC_DIR/$(date +'screencast_%Y%m%d%H%M%S.mp4')"

    wl-screenrec -g "$(slurp && dunstify "Starting screencast" --timeout=1000)" --filename $FILE &&
    ffmpeg -i $FILE -ss 00:00:00 -vframes 1 /tmp/screenrec_thumbnail.png -y &&
    printf -v out "`dunstify "Recording saved to $FILE" \
        --icon "/tmp/screenrec_thumbnail.png" \
        --action="default,Open"`"
  '';

  extras = {
    desktop = {
      monitor = [
        "DP-1, 3440x1440@165, 0x0, 1, vrr, 3, bitdepth, 10, cm, auto"
        "HDMI-A-1,preferred,-1440x-600,1, transform, 3"
      ];

      cursor.no_hardware_cursors = true; # NVIDIA and Wayland bug
    };

    laptop = {
      monitor = [
        "eDP-1,2880x1800@120,0x0, 1.25"
        "eDP-2,2880x1800@120,0x0, 1.25" # ???? Why is there a 2nd eDP on laptop
        ", preferred, auto, 1"
      ];

      input.sensitivity = 0.5;
    };
  };
in
{
  home.packages = with pkgs; [
    wlr-randr
    backgrounds
    audioSwitcher
    hyprland-activewindow
  ];

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  # TODO: remove once swww issue is fixed
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${backgrounds-dir}/share/backgrounds/desktop/ultrawide.png
    preload = ${backgrounds-dir}/share/backgrounds/desktop/2nd.jpg
    wallpaper = DP-1, ${backgrounds-dir}/share/backgrounds/desktop/ultrawide.png
    wallpaper = HDMI-A-1, ${backgrounds-dir}/share/backgrounds/desktop/2nd.jpg
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    package = lib.mkDefault inputs.hyprland.packages.${system}.hyprland;
    plugins = [
      inputs.hyprsplit.packages.${system}.hyprsplit
    ];

    settings = lib.mkMerge [
      {
        exec-once = [
          "${backgrounds}/bin/backgrounds"
          "${pkgs.copyq}/bin/copyq"
          "${inputs.hyprland.packages.${system}.hyprland}/bin/hyprctl setcursor ${config.cursor.name} ${toString config.cursor.size}"
        ]
        ++ (
          if "${host}" == "laptop" then
            [
              "${pkgs.eww}/bin/eww open laptopMain"
            ]
          else if "${host}" == "desktop" then
            [
              "${pkgs.eww}/bin/eww open-many main0 main1"
              "xrandr --output DP-1 --primary"
              "${pkgs.openrgb}/bin/openrgb -p ~/.config/OpenRGB/White.orp" # TODO: Make this nixified
            ]
          else
            [ ]
        );

        env = [
          "XCURSOR_SIZE,${toString config.cursor.size}"
          "XCURSOR_THEME,${config.cursor.name}"
          "HYPRCURSOR_SIZE,${toString config.cursor.size}"
          "HYPRCURSOR_THEME,${config.cursor.name}"
        ]
        ++ (
          if "${host}" == "laptop" then
            [
              "AQ_DRM_DEVICES,/dev/dri/amd-igpu:/dev/dri/nvidia-gpu"
            ]
          else if "${host}" == "desktop" then
            [
              "LIBVA_DRIVER_NAME,nvidia"
              "XDG_SESSION_TYPE,nvidia"
              "GDM_BACKEND,nvidia-drm"
              "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            ]
          else
            [ ]
        );

        input = {
          kb_layout = "us";

          follow_mouse = 1;
          accel_profile = "flat";

          touchpad = {
            natural_scroll = false;
            clickfinger_behavior = true;
            tap-to-click = false;
            disable_while_typing = false;
          };

          sensitivity = lib.mkDefault 0; # -1.0 - 1.0, 0 means no modification.
        };

        general = {
          gaps_in = 2;
          gaps_out = 4;
          border_size = 2;
          "col.active_border" = "rgb(${config.colorScheme.palette.base0D})";
          "col.inactive_border" = "rgb(${config.colorScheme.palette.base03})";

          layout = "dwindle";
        };

        decoration = {
          rounding = 5;
          shadow = {
            enabled = false;
            range = 5;
            render_power = 3;
            color = "rgb(${config.colorScheme.palette.base0D})";
            color_inactive = "rgb(${config.colorScheme.palette.base03})";
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 4, myBezier"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 4, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        gesture = [
          "3, horizontal, workspace"
        ];

        xwayland = {
          force_zero_scaling = true;
        };

        misc = {
          disable_hyprland_logo = true;
          middle_click_paste = false;
        };

        debug.disable_logs = false;

        plugin = {
          hyprsplit = {
            num_workspaces = 9;
          };
        };

        # windowrulev2 = [
        #   "float,class:(copyq)"
        #   "float,title:(VPN_)"
        #   "move onscreen cursor,class:(copyq)"
        # ];

        "$mod" = "SUPER";

        misc.enable_anr_dialog = false;

        bind = [
          "$mod, RETURN, exec, alacritty"
          "$mod, E, exec, firefox-devedition -P dev-edition-default"
          "$mod SHIFT, E, exec, firefox-devedition -P School"
          "$mod, F, fullscreen"
          "$mod, Q, killactive"
          "$mod, G, togglefloating"
          "$mod, R, exec, rofi -show drun"
          "$mod, P, pseudo"
          "$mod, J, togglesplit"
          "$mod, a, movefocus, l"
          "$mod, d, movefocus, r"
          "$mod, w, movefocus, u"
          "$mod, s, movefocus, d"
          "$mod SHIFT, a, movewindow, l"
          "$mod SHIFT, d, movewindow, r"
          "$mod SHIFT, w, movewindow, u"
          "$mod SHIFT, s, movewindow, d"
          "$mod, 1, split:workspace, 1"
          "$mod, 2, split:workspace, 2"
          "$mod, 3, split:workspace, 3"
          "$mod, 4, split:workspace, 4"
          "$mod, 5, split:workspace, 5"
          "$mod, 6, split:workspace, 6"
          "$mod, 7, split:workspace, 7"
          "$mod, 8, split:workspace, 8"
          "$mod, 9, split:workspace, 9"
          "$mod SHIFT, 1, split:movetoworkspace, 1"
          "$mod SHIFT, 2, split:movetoworkspace, 2"
          "$mod SHIFT, 3, split:movetoworkspace, 3"
          "$mod SHIFT, 4, split:movetoworkspace, 4"
          "$mod SHIFT, 5, split:movetoworkspace, 5"
          "$mod SHIFT, 6, split:movetoworkspace, 6"
          "$mod SHIFT, 7, split:movetoworkspace, 7"
          "$mod SHIFT, 8, split:movetoworkspace, 8"
          "$mod SHIFT, 9, split:movetoworkspace, 9"
          "$mod SHIFT, 0, split:movetoworkspace, 10"
          "$mod, L, exec, hyprlock"
          "CTRL SHIFT, Print, exec, grimblast --notify copysave screen $XDG_SCREENSHOT_DIR/$(date '+%b.%d.%Y-%H:%M:%S')-screenshot.png" # Screenshots
          "SHIFT, Print, exec, grimblast --notify copysave area $XDG_SCREENSHOT_DIR/$(date '+%b.%d.%Y-%H:%M:%S')-screenshot.png"

          "ALT, Print, exec, ${screen-rec}/bin/screen-rec" # Screenrec

          "$mod, V, exec, rofi-copyq" # Clipboard

          ",XF86AudioNext, exec, playerctl next" # Switch audio sinks/songs
          ",XF86AudioPrev, exec, playerctl previous"
          ",XF86AudioPlay, exec, playerctl play-pause"
          "$mod SHIFT, O, exec, ${audioSwitcher}/bin/audioSwitcher Sinks"
          "$mod SHIFT, I, exec, ${audioSwitcher}/bin/audioSwitcher Sources"

          "$mod, mouse_down, workspace, e+1" # Scroll though
          "$mod, mouse_up, workspace, e-1"

        ]
        ++ (
          if "${host}" == "laptop" then
            [
              # Laptop specific
              "CTRL SHIFT, code:72, exec,  grimblast --notify copysave screen $XDG_SCREENSHOT_DIR/$(date '+%b.%d.%Y-%H:%M:%S')-screenshot.png"
              "SHIFT, code:72, exec,  grimblast --notify copysave area $XDG_SCREENSHOT_DIR/$(date '+%b.%d.%Y-%H:%M:%S')-screenshot.png"
              "ALT, code:72, exec,  ${screen-rec}/bin/screen-rec"
              "$mod, RIGHT, exec, playerctl next"
              "$mod, LEFT, exec, playerctl previous"
            ]
          else if "${host}" == "desktop" then
            [
              # Desktop specific

            ]
          else
            [ ]
        );

        binde = [
          ",XF86AudioRaiseVolume, exec, amixer set Master 5%+" # More audio
          ",XF86AudioLowerVolume, exec, amixer set Master 5%-"
          ",XF86AudioStop, exec, playerctl stop"
          ",XF86AudioPlay, exec, playerctl play"
        ]
        ++ (
          if "${host}" == "laptop" then
            [
              ",XF86MonBrightnessDown, exec, brightnessctl -m -d $(brightnessctl -l | grep amdgpu_bl | awk '{print $2}' | sed \"s/'//g\") s 5%-"
              ",XF86MonBrightnessUp, exec, brightnessctl -m -d $(brightnessctl -l | grep amdgpu_bl | awk '{print $2}' | sed \"s/'//g\") s 5%+"
              ",XF86KbdBrightnessUp, exec, brightnessctl -m --device='asus::kbd_backlight' s 1+"
              ",XF86KbdBrightnessDown, exec, brightnessctl -m --device='asus::kbd_backlight' s 1-"
            ]
          else if "${host}" == "desktop" then
            [

            ]
          else
            [ ]
        );

        bindm = [
          "$mod, mouse:272, movewindow" # Move windows with mouse
          "$mod, mouse:273, resizewindow" # Resize windows with mouse
        ];

        bindl = [

        ]
        ++ (
          if "${host}" == "laptop" then
            [
              ",switch:[Lid Switch]:on, exec, hyprlock"
            ]
          else
            [ ]
        );
      }
      extras.${host}
    ];
  };
}
