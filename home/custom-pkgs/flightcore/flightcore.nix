{ 
lib
, fetchFromGitHub
, stdenv 
, nodejs_20
, cargo-tauri
, rustPlatform
, buildNpmPackage
}:

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
    sourceRoot = "sources/src-vue";

    packageJSON = ./package.json;
    
    installPhase = ''
      npm run build --offline
    '';

    dontInstall = true;
    distPhase = true;
  };


in 
rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "source/src-tauri";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-store-0.1.0" = "";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock

    mkdir -p frontend-build
    cp -R ${frontend-build}/src frontend-build

    substituteInPlace tauri.conf.json --replace '"distDir": "../src-vue/dist",' '"distDir": "frontend-build/dist",'
  '';
  
  meta = with lib; {
    description = "Flight Core";
    homepage = "https://github.com/R2NorthstarTools/FlightCore";
    license = licenses.mit;
    maintainers = [ maintainers.totaltaxamount ];
  };
}
