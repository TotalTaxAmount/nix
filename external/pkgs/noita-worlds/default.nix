{
  rustPlatform,
  fetchFromGitHub,
  python3,
  libxcb,
  wayland,
  wayland-protocols,
  libGL,
  libxkbcommon,
  xorg,
  makeWrapper,
  lib,
  curl,
  steam-run,
}:

rustPlatform.buildRustPackage rec {
  pname = "noita_entangled_worlds";
  version = "v0.28.0";

  src = fetchFromGitHub {
    owner = "IntQuant";
    repo = pname;
    rev = "0986cb1938391602cd3715181e159620e65b2602";
    hash = "sha256-Buq+HRiuwnjDHFQKsY7OL+mi/DdjSOj1vbZspfdiWJ0=";
  };

  sourceRoot = "${src.name}/noita-proxy";

  buildInputs = [
    libGL
    libxkbcommon
    wayland
    wayland.dev
    wayland-protocols
    libxcb
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    curl
    steam-run
  ];

  nativeBuildInputs = [
    python3
    makeWrapper
  ];

  doCheck = false;

  postInstall = ''
    cp ${src}/redist/libsteam_api.so $out/bin/
  '';

  postFixup = ''
    wrapProgram "$out/bin/noita-proxy" \
          --chdir /tmp \
          --set LD_LIBRARY_PATH ${lib.makeLibraryPath buildInputs}          
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "steamworks-0.11.0" = "sha256-brAAzwJQpefWJWCveHqBLvrlAi0tUn07V/XkWXCj8PE=";
    };
  };
}
