{ rustPlatform, fetchFromGitHub, }:

rustPlatform.buildRustPackage rec {
  pname = "noita_entangled_worlds";
  version = "v0.27.1";

  src = fetchFromGitHub {
    owner = "IntQuant";
    repo = pname;
    rev = version;
    hash = "sha256-zrQ6T9Y9ZcyCXl446kv+a17xxf/yS/K5qKig8KbDcJs=";
  };

  buildInputs = [];

  doCheck = false;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "steamworks-0.11.0" = "sha256-brAAzwJQpefWJWCveHqBLvrlAi0tUn07V/XkWXCj8PE=";
    };
  };

  sourceRoot = "${src.name}/noita-proxy";
}
