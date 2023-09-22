{pkgs, config, ...}:

{
  home.packages = with pkgs; [xplorer];
}