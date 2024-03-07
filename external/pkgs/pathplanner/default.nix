{ fetchFromGitHub
, flutter
, lib
}:

flutter.buildFlutterApplication rec {
  pname = "pathplanner";
  version = "v2024.1.4";

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = pname;
    rev = "db1bd38";
    hash = "";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

}

