{ fetchFromGitHub, python314Packages }:

python314Packages.buildPythonPackage rec {
  pname = "rofi-copyq";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "cjbassi";
    repo = pname;
    rev = "2ce8628b1e17d91c82d6d40302f1325f3edee207";
    hash = "sha256-xDxdKitVDonNhoNPMAoHizoaijQj9UQGSCPhWJOcB1w=";
  };

  pyproject = true;
  build-system = [ python314Packages.setuptools ];

  patches = [ ./better_type.patch ];
}
