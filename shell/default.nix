{ stdenv,
  substituteInPlace
}:

stdenv.mkDerivation rec {
  pname = "shell";
  version = "1.0.0";

  src = .;

  configurePhase = ''
    substituteInPlace $src/shell.sh --replace 'path' '$out/shells' 
  '';

  installPhase = ''
    cp $src/shells $out/shells
  '';
}