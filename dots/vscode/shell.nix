{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {

  nativeBuildInputs = with pkgs; [
    nodejs_20
    nodePackages.generator-code
    nodePackages.yo
  ];
}
