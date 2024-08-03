{ pkgs, config, ... }:

let
  btopTheme = pkgs.substituteAll {
    src = ../../../../dots/btop/themes/system.theme;
    base00 = "#${config.colorScheme.palette.base00}";
    base03 = "#${config.colorScheme.palette.base03}";
    base04 = "#${config.colorScheme.palette.base04}";
    base05 = "#${config.colorScheme.palette.base05}";
    base06 = "#${config.colorScheme.palette.base06}";
    base07 = "#${config.colorScheme.palette.base07}";
    base0C = "#${config.colorScheme.palette.base0C}";
    base0D = "#${config.colorScheme.palette.base0D}";
    base0F = "#${config.colorScheme.palette.base0F}";
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
