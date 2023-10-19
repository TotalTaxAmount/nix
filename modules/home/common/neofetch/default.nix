{pkgs, ...}:

{
  home.packages = with pkgs; [neofetch];

  xdg.configFile."neofetch/config.conf".source = ../../../dots/neofetch/config.conf;
}