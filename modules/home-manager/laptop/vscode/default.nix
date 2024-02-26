{pkgs, config, user, ...}:
# TODO: Make the theme a real extension in nix
let
  vscodeThemeExtension = pkgs.substituteAllFiles {
    src = ../../../../dots/vscode/systemtheme;
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

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
      ms-vscode.cpptools
      ms-vscode-remote.remote-ssh
      mkhl.direnv
      jnoortheen.nix-ide
      ms-vscode.makefile-tools

    ] ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "onedark";
        publisher = "bartoszmaka95";
        version = "0.2.1";      
        sha256 = "sha256-j03kdtx9CqypUsBGk04mtvTvPf5Uy36c+wnJaOGFaNU=";
      }
    ]);
  };

  home.file.".vscode/extensions/totaltax.systemtheme-1.0.0".source = vscodeThemeExtension.out;
  xdg.configFile."Code/User/settings.json".source = ../../../../dots/vscode/settings.json;
  xdg.configFile."Code/User/keybindings.json".source = ../../../../dots/vscode/keybinds.json;
}
