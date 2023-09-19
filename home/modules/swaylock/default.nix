{ pkgs, config, ...}:

let
  swaylockConfig = pkgs.substituteAll {
    src = ../../../dots/swaylock/config;
    base00 = "${config.colorScheme.colors.base00}";
    base05 = "${config.colorScheme.colors.base05}";
    base08 = "${config.colorScheme.colors.base08}";

  };
in
{
  home.packages = with pkgs; [ swaylock-effects ];

  xdg.configFile."swaylock/config".source = swaylockConfig.out;
}