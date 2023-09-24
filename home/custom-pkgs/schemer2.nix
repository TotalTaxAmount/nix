{lib
, buildGoPackage
, fetchFromGithub
}:

buildGoPackage {
  pname = "schemer2";
  version = "1.0.0";

  src = fetchFromGithub {
    owner = "thefryscorer";
    repo = pname;
    rev = "89a66cbf40440e82921719c6919f11bb563d7cfa";
  };

  doCheck = false;
  meta = with lib; {
    description = "Gets colors from an image?";
    homepage = "https://github.com/thefryscorer/schemer2";
    maintainers = with maintainers; [ totaltaxamount ];
  };
}