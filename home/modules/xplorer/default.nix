{pkgs, config, ...}:

let 
  theme = pkgs.substituteAll {
    src = "../../../dots/xplorer/systemTheme.xtension";
    base00 = "#${config.colorScheme.colors.base00}";
  };
in 
{
  home.packages = with pkgs; [xplorer];
}