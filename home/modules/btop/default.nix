{pkgs, config, ...}:

let
  btopTheme = pkgs.substituteAll {
    src = ../../../dots/btop/themes/theme.conf;
    base00 = "#${config.colorScheme.colors.base00}";
    base03 = "#${config.colorScheme.colors.base03}";
    base04 = "#${config.colorScheme.colors.base04}";
    base06 = "#${config.colorScheme.colors.base06}";
    base07 = "#${config.colorScheme.colors.base07}";
    base0C = "#${config.colorScheme.colors.base0C}";
    base0D = "#${config.colorScheme.colors.base0D}";
    base0F = "#${config.colorScheme.colors.base0F}";
  }
in
{
  programs.btop = {
    enable = true;
  };

  xdg.configFile."btop/themes/theme.conf".source = btopTheme.out;
}