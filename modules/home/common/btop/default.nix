{pkgs, config, ...}:

let
  btopTheme = pkgs.substituteAll {
    src = ../../../dots/btop/themes/system.theme;
    base00 = "#${config.colorScheme.colors.base00}";
    base03 = "#${config.colorScheme.colors.base03}";
    base04 = "#${config.colorScheme.colors.base04}";
    base06 = "#${config.colorScheme.colors.base06}";
    base07 = "#${config.colorScheme.colors.base07}";
    base0C = "#${config.colorScheme.colors.base0C}";
    base0D = "#${config.colorScheme.colors.base0D}";
    base0F = "#${config.colorScheme.colors.base0F}";
  };
in
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "system";
      enable_gpu = true;
      shown_boxes = "proc cpu mem net gpu0";
    };
  };

  xdg.configFile."btop/themes/system.theme".source = btopTheme.out;
}