{ config, pkgs, ...}:

{
  home.packages = [ (pkgs.callPackage ../../../../shell { }) ];
}