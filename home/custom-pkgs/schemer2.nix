{ lib
, buildGoPackage
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "schemer2";
  version = "1.0.0";

  goPackagePath = "github.com/thefryscorer/schemer2";

  src = fetchFromGitHub {
    owner = "thefryscorer";
    repo = "schemer2";
    rev = "89a66cbf40440e82921719c6919f11bb563d7cfa";
    hash = "sha256-EKjVz4NkxtxqGissFwlzUahFut9UAxS8icxx3V7aNnw=";
  };

  doCheck = false;
  meta = with lib; {
    description = "Gets colors from an image?";
    homepage = "https://github.com/thefryscorer/schemer2";
    maintainers = with maintainers; [ totaltaxamount ];
  };
}