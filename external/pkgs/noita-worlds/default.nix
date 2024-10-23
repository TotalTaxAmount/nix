{rustPlatform
, fetchFromGitHub
, python3
, libxcb
, wayland
, wayland-protocols
, libGL
, libxkbcommon
, xorg
, makeWrapper
, lib 
, curl
, steam-run }:

rustPlatform.buildRustPackage rec {
  pname = "noita_entangled_worlds";
  version = "v0.27.5";

  src = fetchFromGitHub {
    owner = "IntQuant";
    repo = pname;
    rev = version;
    hash = "sha256-6xT8USJkE6QTrXGYsW9kN2Bmp8J2r29XFAcFB/T8aKY=";
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
