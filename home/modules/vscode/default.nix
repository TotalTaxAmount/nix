{pkgs, config, user, ...}:

let
  vscodeThemeExtension = pkgs.substituteAllFiles {
    src = ../../../dots/vscode/systemtheme;
    files = [
      "themes/System\ Theme-color-theme.json"
      "themes/system.tmTheme"
      "README.md"
      ".vscode/launch.json"
      ".vscodeignore"
      "package.json"
      "README.md"
      "CHANGELOG.md"
      "vsc-extension-quickstart.md"
    ];
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

    user = user;
    theme = "${config.colorScheme.name}";
    author = "${config.colorScheme.author}";
  };
in {
  home.packages = with pkgs; [ vscode-fhs ];

  home.file.".vscode/extensions/totaltax.systemtheme-1.0.0".source = vscodeThemeExtension.out;
  xdg.configFile."Code/User/settings.json".source = builtins.readFile ../../../dots/vscode/settings.json;
}