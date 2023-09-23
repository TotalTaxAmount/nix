{pkgs, config, inputs, ...}:

let 
  theme = pkgs.substituteAll {
    src = ../../../dots/xplorer/systemTheme.xtension;
    base00 = "#${config.colorScheme.colors.base00}";
    base01 = "#${config.colorScheme.colors.base01}";
    base03 = "#${config.colorScheme.colors.base03}";
    base04 = "#${config.colorScheme.colors.base04}";
    base05 = "#${config.colorScheme.colors.base05}";
    base07 = "#${config.colorScheme.colors.base07}";
    base08 = "#${config.colorScheme.colors.base08}";
    base0A = "#${config.colorScheme.colors.base0A}";
    base0B = "#${config.colorScheme.colors.base0B}";
    base0C = "#${config.colorScheme.colors.base0C}";
    base0E = "#${config.colorScheme.colors.base0E}";
    base0F = "#${config.colorScheme.colors.base0F}";
  };
in 
{
  home.packages = with pkgs; [xplorer];
  home.file."/.local/share/Xplorer/extensions".text = ''{"themes":[${builtins.readFile theme.out}]}'';
}