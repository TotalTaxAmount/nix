{ config, pkgs, ...}:

let
  shell = pkgs.callPackage ../../../../shell;
in
{
  home.packages = [ shell ];
}