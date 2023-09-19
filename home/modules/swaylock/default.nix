{ pkgs, config, ...}:

{
  home.packages = with pkgs; [ swaylock-effects ]
}