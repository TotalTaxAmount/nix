{ 
lib
, fetchFromGitHub
, stdenv 
, nodejs_20
, cargo-tauri
, mkNodePackage
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

  fontend = mkNodePackage {
    inherit version src;
    sourceRoot = "sources/src-vue";

    packageJSON = ./package.json;
    
    installPhase = ''
      npm run build --offline
    '';

    dontInstall = true;
    distPhase = true;
  };


in 
stdenv.mkDerivation rec {
  inherit pname version src;

  buildInputs = [
    nodejs_20
  ];

  buildPhase = ''
    npx tauri build
  '';
  meta = with lib; {
    description = "Flight Core";
    homepage = "https://github.com/R2NorthstarTools/FlightCore";
    license = licenses.mit;
    maintainers = [ maintainers.totaltaxamount ];
  };
}
