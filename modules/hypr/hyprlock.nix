{ pkgs, config, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        monitor = "";
        path = "screenshot";
        color = "rgb(${config.colorScheme.palette.base00})";
        blur_passes = 2;
        contrast = 1;
        brightness = 0.5;
        vibrancy = 0.2;
        vibrancy_darkness = 0.2;
      };

      general = {
        no_fade_in = true;
        no_fade_out = true;
        hide_cursor = false;
        grace = 0;
        disable_loading_bar = true;
      };

      input-field = {
        monitor = "";
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgb(${config.colorScheme.palette.base0D})";
        inner_color = "rgb(${config.colorScheme.palette.base00})";
        font_color = "rgb(${config.colorScheme.palette.base05})";
        fade_on_empty = false;
        rounding = -1;
        check_color = "rgb(204, 136, 34)"; # TODO: Use a color scheme value;
        placeholder_text = "<i><span foreground='##${config.colorScheme.palette.base03}'>Input Password...</span></i>";
        hide_input = false;
        position = "0, -200";
        halign = "center";
        valign = "center";
      };

      label = [
        # Date
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
          color = "rgb(${config.colorScheme.palette.base05})";
          font_size = 22;
          font_family = "${config.font}";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%-I:%M")"'';
          color = "rgb(${config.colorScheme.palette.base05})";
          font_size = 95;
          font_family = "${config.font}";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        # Greeting
        {
          monitor = "";
          text = ''cmd[update:1000] echo "Hello, $(whoami)"'';
          color = "rgb(${config.colorScheme.palette.base05})";
          font_size = 14;
          font_family = "${config.font}";
          position = "0, -15";
          halign = "center";
          valign = "top";
        }
      ];
    };
  };
}
