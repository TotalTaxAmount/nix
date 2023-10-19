{pkgs, config, lib, ...}:

let 
  colorUtils = import ../../../../utils/color.nix { inherit lib; };
  theme = pkgs.substituteAll {
    src = ../../../../dots/xplorer/systemTheme.xtension;
    base00rgb = "${colorUtils.hexToRGBFormatted config.colorScheme.colors.base00}";
    base01rgb = "${colorUtils.hexToRGBFormatted config.colorScheme.colors.base01}";
    base05rgb = "${colorUtils.hexToRGBFormatted config.colorScheme.colors.base05}";
    base0Ergb = "${colorUtils.hexToRGBFormatted config.colorScheme.colors.base0E}";
    base0Frgb = "${colorUtils.hexToRGBFormatted config.colorScheme.colors.base0F}";

    base01 = "#${config.colorScheme.colors.base01}";
    base05 = "#${config.colorScheme.colors.base05}";
    base0D = "#${config.colorScheme.colors.base0D}";
  };
in 
{
  home.packages = with pkgs; [xplorer];
  home.file."/.local/share/Xplorer/extensions".text = ''{"themes":[${builtins.readFile theme.out}]}'';
}