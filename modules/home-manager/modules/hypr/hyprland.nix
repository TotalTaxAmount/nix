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

    def set_wallpaper_image_swww(path, output=None):
        cmd = [f'${pkgs.swww}/bin/swww', 'img']
        if output:
            cmd += ['-o', output]
        cmd.append(path)
        subprocess.run(cmd)

    if "${host}" in ["laptop", "laptop-strix"]:
        time.sleep(2) 
        subprocess.Popen([f'${pkgs.swww}/bin/swww-daemon'], close_fds=True)
        time.sleep(2)
        wallpaper_dir = Path(f'/home/${user}/nix/dots/swww/wallpapers')
        image_files = list(wallpaper_dir.glob('*.jpg'))

        while True:
            shuffled_files = random.sample(image_files, len(image_files))
            for path in shuffled_files:
                print(f"switch: {path}")
                set_wallpaper_image_swww(path)
                time.sleep(interval)

    elif "${host}" == "desktop":
        subprocess.Popen([f'${pkgs.hyprpaper}/bin/hyprpaper'], close_fds=True)
        # set_wallpaper_image(f'/home/${user}/nix/dots/swww/desktop/ultrawide.png', 'DP-1')
        # set_wallpaper_image(f'/home/${user}/nix/dots/swww/desktop/2nd.jpg', 'HDMI-A-1')

    else:
        exit(1)
  '';

  audioSwitcher = pkgs.writeScriptBin "audioSwitcher" ''
  #!${pkgs.python3}/bin/python
  import sys
  import subprocess

  """
  Wireplumber sink/source switcher

  It lets you pass your sinks/sources into a dmenu dropdown
  for ease of access

  Usage:
  ./wireplumber_audio_switcher.py <Sinks|Sources>
  """

  GROUP_DELIMITER = " ├─"
  ITEM_DELIMITER  = " │  "
  ACCEPTED_GROUPS = set(["Sinks:", "Sources:"])

  def clean_line(line: str):
      line = line.replace(GROUP_DELIMITER, "").replace(ITEM_DELIMITER, "").replace(":", "")
      vol_index = line.find("[")
      if vol_index > 0:
          line = line[:vol_index]
      if "*" in line:
          line = line.replace("*", "")
          splitted = line.split(".")
          splitted[1] = f"<b>{splitted[1].strip()} *</b>"
          line = ". ".join(splitted)
      return line.strip()

  def parse_wpctl_status():
      found_audio_tab = False
      current_subgroup = None
      processed_data = {}
      output = subprocess.run(
          "${pkgs.wireplumber}/bin/wpctl status -k",
          shell=True,
          encoding="utf-8",
          stdout=subprocess.PIPE,
          stderr=subprocess.PIPE,
      )

      for line in output.stdout.split("\n"):
          if not found_audio_tab and line == "Audio":
              found_audio_tab = True

          elif found_audio_tab:
              if line == "":
                  found_audio_tab = False
                  break
              elif line == ITEM_DELIMITER:
                  current_subgroup = None
                  continue
              elif line.startswith(GROUP_DELIMITER):
                  current_subgroup = clean_line(line)
                  processed_data[current_subgroup] = []
                  continue
              elif current_subgroup and line.startswith(ITEM_DELIMITER):
                  processed_data[current_subgroup].append(clean_line(line))
                  continue
      return processed_data

  def pipe_into_dmenu(output):
      output = subprocess.run(
          f"echo '{output}' | ${pkgs.rofi}/bin/rofi -dmenu -markup-rows",
          shell=True,
          encoding="utf-8",
          stdout=subprocess.PIPE,
          stderr=subprocess.PIPE,
      )

      if output.returncode != 0:
          return None
      return output.stdout

  output = parse_wpctl_status()
  sink = pipe_into_dmenu("\n".join(output[sys.argv[1]]))

  if sink:
      sink_id = sink.split(".")[0]
      subprocess.run(
          f"${pkgs.wireplumber}/bin/wpctl set-default {sink_id}",
          shell=True
      )
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
    audioSwitcher = "${audioSwitcher}/bin/audioSwitcher";
    cursorSize = config.cursor.size;
    cursorTheme = config.cursor.name;
  };
in
{
  home.packages = with pkgs; [
    wlr-randr
    backgrounds
    audioSwitcher
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

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = /home/${user}/nix/dots/swww/desktop/ultrawide.png
    preload = /home/${user}/nix/dots/swww/desktop/2nd.jpg
    wallpaper = DP-1, /home/${user}/nix/dots/swww/desktop/ultrawide.png
    wallpaper = HDMI-A-1, /home/${user}/nix/dots/swww/desktop/2nd.jpg
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # enableNvidiaPatches = true;
    extraConfig = builtins.readFile hyprConfig.out;
    package = lib.mkDefault inputs.hyprland.packages.${system}.hyprland;
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      #     inputs.hyprsplit.packages.${system}.hyprsplit
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
