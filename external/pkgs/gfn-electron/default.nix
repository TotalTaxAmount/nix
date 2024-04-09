{buildNpmPackage ,
fetchFromGitHub ,
}:

buildNpmPackage rec {
  pname = "gfn-electron";
  version = "v2.1.0";

  src = fetchFromGitHub {
    owner = "hmlendea";
    repo = pname;
    rev = version;
    hash = "";
  };
}