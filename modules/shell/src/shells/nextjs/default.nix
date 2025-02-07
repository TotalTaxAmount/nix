{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  name = "nextjs";
  buildInputs = with pkgs; [
    nodePackages.create-react-app
    nodejs
    yarn
  ];
}
