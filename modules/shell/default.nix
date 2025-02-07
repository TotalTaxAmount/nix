{ stdenv }:

stdenv.mkDerivation rec {
  name = "shell-1.0.0";

  src = ./src;

  installPhase = ''
    mkdir -p $out/shells
    cp -r $src/shells $out/

    mkdir -p $out/bin
    cp $src/shell.sh $out/bin/shell
    substituteInPlace $out/bin/shell --replace 'path' "$out/shells"

  '';
}
