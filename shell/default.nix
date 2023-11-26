{ stdenv }:

stdenv.mkDerivation rec {
  name = "shell-1.0.0";

  src = ./src;

  # patchPhase = ''
  #   substituteInPlace $src/shell.sh --replace 'path' '$out/shells' 
  # '';

  installPhase = ''
    mkdir -p $out/bin
    mv $src/shell.sh $out/bin
  '';
}