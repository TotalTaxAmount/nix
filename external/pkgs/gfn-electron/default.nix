{ buildNpmPackage, fetchFromGitHub, }:

buildNpmPackage rec {
  pname = "gfn-electron";
  version = "v2.1.0";

  src = fetchFromGitHub {
    owner = "hmlendea";
    repo = pname;
    rev = version;
    hash = "sha256-xl9p4In8WfwSZ2eKEFSPvKYVMUVKDA6fnyA5pE5K/gQ=";
  };

  npmDepsHash = "sha256-JZxL3YUsjOD50r48A3jh94edKPw0qHgcFHzDOSpbtDY=";
  makeCacheWritable = true;
  npmFlags = "--openssl-legacy-provider";
  forceGitDeps = true;
}
