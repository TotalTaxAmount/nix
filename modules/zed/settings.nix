{ config }:
{
  # language_modles = {
  #   google.available_models = [
  #     # {
  #     #   name = "gem"
  #     # }
  #   ];
  # };
  #
  agent = {
    defualt_model = {
      provider = "google";
      model = "gemini-3-pro";
    };
  };

  # Coere
  # hour_format = "hour24";
  vim_mode = false;
  load_direnv = "shell_hook";
  base_keymap = "VSCode";

  # Theme
  theme = "One Dark - Darkened";
  icon_theme = "Material Icon Theme";
  project_panel = {
    indent_guides.show = "never";
  };
  ui_font_size = 16;

  toolbar = {
    breadcrumbs = false;
  };

  # Buffer
  buffer_font_size = 14;
  buffer_font_family = config.font;
  buffer_font_features = {
    calt = true; # VSCode: editor.fontLigatures: true
  };
  tab_size = 2;
  show_whitespaces = "selection";
  cursor_blink = true;

  indent_guides = {
    enabled = false; # VSCode: editor.guides.indentation: false
  };

  file_scan_exclusions = [
    "**/.git/objects/**"
    "**/.git/subtree-cache/**"
    "**/node_modules/*/**"
    "**/.hg/store/**"
  ];

  languages = {
    Java = {
      format_on_save = "off";
      enable_language_server = true;
      formatter = null;
    };
  };
}
