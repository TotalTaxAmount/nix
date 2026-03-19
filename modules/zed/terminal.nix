{config}: {
  alternate_scroll = "off";
  blinking = "off";
  copy_on_select = false;
  dock = "bottom";
  detect_venv = {
    on = {
      directories = [".env" "env"];
      activate_script = "default";
    };
  };
  env = {
    TERM = "alacritty";
  };
  font_family = config.font;
  working_directory = "current_project_directory";
}