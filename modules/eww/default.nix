{
  pkgs,
  config,
  user,
  ...
}:
let
  scriptDir = builtins.dirOf ./config/scripts/battery.sh;
  ewwCfg = pkgs.substituteAllFiles {
    src = ./config;
    files = [
      "modules/info.yuck"
      "modules/system.yuck"
      "modules/main.yuck"

      "scripts/battery.sh"
      "scripts/currentapp.sh"
      "scripts/music_utils.sh"
      "scripts/music.sh"
      "scripts/pop.sh"
      "scripts/sys_info.sh"
      "scripts/vpn.sh"

      "eww.scss"
      "eww.yuck"
      "nixos-icon.svg"
    ];
    base00 = "#${config.colorScheme.palette.base00}";
    base01 = "#${config.colorScheme.palette.base01}";
    base03 = "#${config.colorScheme.palette.base03}";
    base05 = "#${config.colorScheme.palette.base05}";
    base08 = "#${config.colorScheme.palette.base08}";
    base0A = "#${config.colorScheme.palette.base0A}";
    base0B = "#${config.colorScheme.palette.base0B}";
    base0C = "#${config.colorScheme.palette.base0C}";
    base0D = "#${config.colorScheme.palette.base0D}";

    font = "${config.font}";
    scriptdir = "${scriptDir}";
  };

  final = pkgs.runCommand "script-permissions" { } ''
    mkdir -p $out
    cp -r ${ewwCfg.out}/* $out
    chmod +x $out/scripts/*.sh
  '';

  hyprland-workspaces_updated = pkgs.callPackage ../../external/pkgs/hyprland-workspaces { };
in
{

  programs.eww = {
    enable = true;
    configDir = final.out;
  };
  home.packages = with pkgs; [
    bc
    hyprland-workspaces_updated
  ];

}
