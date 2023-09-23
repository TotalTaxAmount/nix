{pkgs, config, inputs, ...}:

let 
  colorUtils = import ../../../utils/colors.nix;
  theme = pkgs.substituteAll {
    src = ../../../dots/xplorer/systemTheme.xtension;
  };
in 
{
  home.packages = with pkgs; [xplorer];
  home.file."/.local/share/Xplorer/extensions".text = ''{"themes":[${builtins.readFile theme.out}]}'';
}