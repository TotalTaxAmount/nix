{pkgs, config, inputs, ...}:

let 
  colorUtils = import inputs.nix-colors.lib.conversions {};
  theme = pkgs.substituteAll {
    src = ../../../dots/xplorer/systemTheme.xtension;
    base00 = (colorUtils.hexToRgb config.colorScheme.colors.base00);
  };
in 
{
  home.packages = with pkgs; [xplorer];
  home.file."/.local/share/Xplorer/extensions".text = ''{"themes":[${builtins.readFile theme.out}]}'';
}