{pkgs, config, ...}:

{
  services.dunst = {
	  enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = "320";
        offset = "10x4";
        indicate_hidden = true;
        shrink = false;
        transparency = 0;
        separator_height = 2;
        padding = 8;
        gap_size = 5;
        horizontal_padding = 3;
        frame_width = 2;
        frame_color = "#${config.colorScheme.colors.base05}";
        separator_color = "frame";
        sort = true;
        idle_threshold = 120;
        line_height = 0;
        markup = "full";
        format = "<span foreground='#f3f4f5'><b>%s %p</b></span>\\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = true;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        icon_position = "left";
        max_icon_size = 32;
        sticky_history = true;
        history_length = 20;
        always_run_script = true;
        progress_bar = true;
        corner_radius = 8;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_all";
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
      };
      urgency_low = {
        background = "#${config.colorScheme.colors.base00}";
        foreground = "#${config.colorScheme.colors.base05}";
        timeout = 8;
      };
      urgency_normal = {
        background = "#${config.colorScheme.colors.base00}";
        foreground = "#${config.colorScheme.colors.base05}";
        timeout = 8;
      };
      urgency_critical = {
        background = "#${config.colorScheme.colors.base00}";
        foreground = "#${config.colorScheme.colors.base0B}";
        frame_color = "#${config.colorScheme.colors.base0B}";
        timeout = 0;
      };
    };
  };
}