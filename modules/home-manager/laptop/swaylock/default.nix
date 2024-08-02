{ pkgs, config, ... }:

let
  swaylockConfig = pkgs.substituteAll {
    src = ../../../../dots/swaylock/config;
    base00 = "${config.colorScheme.palette.base00}";
    base05 = "${config.colorScheme.palette.base05}";
    base08 = "${config.colorScheme.palette.base08}";
    font = "${config.font}";

  };
in
{
  home.packages = with pkgs; [ swaylock-effects ];

  xdg.configFile."swaylock/config".source = swaylockConfig.out;
}
