{ fetchFromGithub
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "rofi-copyq";
  version = "0.1.1";

  src = fetchFromGithub {
    owner = "cjbassi";
    repo = pname;
    rev = "2ce8628b1e17d91c82d6d40302f1325f3edee207";
  };
}

