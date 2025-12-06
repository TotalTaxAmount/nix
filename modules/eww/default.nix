{
  pkgs,
  config,
  user,
  ...
}:

let
  scripts = pkgs.runCommand "scripts" { } ''
    mkdir -p $out
    cp -r ${./config/scripts}/* $out
  '';

  info-yuck = pkgs.replaceVarsWith {
    src = ./config/modules/info.yuck;
    replacements.scriptdir = scripts;
    name = "info.yuck";
    dir = "modules";
    isExecutable = false;
  };

  system-yuck = pkgs.replaceVarsWith {
    src = ./config/modules/system.yuck;
    replacements.scriptdir = scripts.out;

    name = "system.yuck";
    dir = "modules";
    isExecutable = false;
  };

  main-yuck = pkgs.replaceVarsWith {
    src = ./config/modules/main.yuck;
    replacements.scriptdir = scripts.out;

    name = "main.yuck";
    dir = "modules";
    isExecutable = false;
  };

  eww-scss = pkgs.replaceVarsWith {
    src = ./config/eww.scss;
    replacements = {
      base00 = "#${config.colorScheme.palette.base00}";
      base01 = "#${config.colorScheme.palette.base01}";
      base03 = "#${config.colorScheme.palette.base03}";
      base05 = "#${config.colorScheme.palette.base05}";
      base0A = "#${config.colorScheme.palette.base0A}";
      base0B = "#${config.colorScheme.palette.base0B}";
      base0C = "#${config.colorScheme.palette.base0C}";
      base0D = "#${config.colorScheme.palette.base0D}";

      font = "${config.font}";
    };

    name = "eww.scss";
    dir = ".";
    isExecutable = false;
  };

  nixos-icon = pkgs.replaceVarsWith {
    src = ./config/nixos-icon.svg;
    replacements = {
      base0C = "#${config.colorScheme.palette.base0C}";
      base0D = "#${config.colorScheme.palette.base0D}";
    };
    name = "nixos-icon.svg";
    dir = ".";
    isExecutable = false;
  };

  ewwConfig = pkgs.runCommand "eww-config-compiled" { } ''
    mkdir -p $out/modules
    cp -r ${info-yuck.out}/* $out
    cp -r ${main-yuck.out}/* $out
    cp -r ${system-yuck.out}/* $out
    cp -r ${nixos-icon.out}/* $out
    cp -r ${eww-scss.out}/* $out

    cp ${./config/eww.yuck} $out/eww.yuck
  '';

  hyprland-workspaces_updated = pkgs.callPackage ../../external/pkgs/hyprland-workspaces { };

in
{
  programs.eww = {
    enable = true;
    configDir = ewwConfig.out;
  };

  home.packages = with pkgs; [
    bc
    hyprland-workspaces_updated
  ];
}
