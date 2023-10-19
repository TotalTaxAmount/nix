{pkgs, config, ...}:

let
  theme = pkgs.substituteAllFiles {
    src = ../../../../dots/prismLauncher/theme;
    files = [
      "preview.png"
      "preview.png.license"
      "theme.json"
      "theme.json.license"
      "themeStyle.css"
    ];

    base00 = "#${config.colorScheme.colors.base00}";
    base01 = "#${config.colorScheme.colors.base01}";
    base04 = "#${config.colorScheme.colors.base04}";
    base0C = "#${config.colorScheme.colors.base0C}";
  };
in {
  home.packages = with pkgs; [ prismlauncher-qt5 ];

  # home.file.".local/share/PrismLauncher/themes/system".source = theme.out;
}
