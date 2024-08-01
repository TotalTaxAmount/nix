{ lib, fetchFromGitHub, fetchNpmDeps, stdenv, nodejs_20, cargo-tauri
, rustPlatform, buildNpmPackage }:

let
  pname = "flight-core";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "R2NorthstarTools";
    repo = "FlightCore";
    rev = "v${version}";
    hash = "sha256-re1xU5Cx8ot1eFpNfT4cLCVYJlSEwJNzx7jYHmUnAfM=";
  };

  frontend-build = buildNpmPackage rec {
    inherit pname version src;

    sourceRoot = "${src.name}/src-vue";

    npmDepsHash = "sha256-X5gOO/ynx+I69brGFhqXtFEhb0AQLqv2vA4eLo7rZkE=";

    buildPhase = ''
      echo 'We made it!'
    '';

    dontInstall = true;
    makeCacheWritable = true;
    distPhase = true;
  };

in rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "${src.name}/src-tauri";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-store-0.1.0" =
        "sha256-G7b1cIMr7YcI5cUhlYi4vhLFCe3/CMSPSB4gYY1Ynz8=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock

    mkdir -p frontend-build

    substituteInPlace tauri.conf.json --replace '"distDir": "../src-vue/dist",' '"distDir": "frontend-build/dist",'
  '';

  meta = with lib; {
    description = "Flight Core";
    homepage = "https://github.com/R2NorthstarTools/FlightCore";
    license = licenses.mit;
    maintainers = [ maintainers.totaltaxamount ];
  };
}
