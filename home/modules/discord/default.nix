{pkgs, config, ...}:

let
  theme = pkgs.substituteAll {
    src = ../../../dots/discord/system.theme.css;
    base00 = "#${config.colorScheme.colors.base00}";
    base01 = "#${config.colorScheme.colors.base01}";
    base02 = "#${config.colorScheme.colors.base02}";
    base03 = "#${config.colorScheme.colors.base03}";
    base04 = "#${config.colorScheme.colors.base04}";
    base05 = "#${config.colorScheme.colors.base05}";
    base06 = "#${config.colorScheme.colors.base06}";
    base07 = "#${config.colorScheme.colors.base07}";
    base08 = "#${config.colorScheme.colors.base08}";
    base09 = "#${config.colorScheme.colors.base09}";
    base0A = "#${config.colorScheme.colors.base0A}";
    base0B = "#${config.colorScheme.colors.base0B}";
    base0C = "#${config.colorScheme.colors.base0C}";
    base0D = "#${config.colorScheme.colors.base0D}";
    base0E = "#${config.colorScheme.colors.base0E}";
    base0F = "#${config.colorScheme.colors.base0F}";
  };
in {
  home.packages = with pkgs; [discord];

  xdg.configFile."Vencord/themes/system.theme.css";
}