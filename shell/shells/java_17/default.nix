{ pkgs ? import <nixpkgs> {} }:


pkgs.stdenv.mkDerivation {
  name = "java_17";
  buildInputs = with pkgs; [
    jdk17
  ];
  shellHook = ''
    export JAVA_HOME=${pkgs.jdk17}
  '';
}