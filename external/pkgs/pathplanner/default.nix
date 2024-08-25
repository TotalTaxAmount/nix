{
  fetchFromGitHub,
  flutter,
  lib,
  libuuid,
  makeDesktopItem,
}:

flutter.buildFlutterApplication rec {
  pname = "pathplanner";
  version = "2024.1.7";

  src = fetchFromGitHub {
    owner = "mjansen4857";
    repo = pname;
    rev = version;
    hash = "sha256-A8HGBpkO4xmUoWS5+Fz5IO81/G0NKI0pIemDgUFN9SY=";
  };

  desktop = makeDesktopItem {
    desktopName = "Path Planner";
    name = pname;
    exec = pname;
    icon = pname;
    comment = "FRC auto tool";
    type = "Application";
    categories = [
      "Application"
      "Utility"
    ];
    genericName = pname;
  };

  buildInputs = [ libuuid ];

  postInstall = ''
    mkdir -p $out/share/icons $out/share/applications
    cp $out/app/data/flutter_assets/images/icon.png $out/share/icons/${pname}.png
    cp ${desktop}/share/applications/${pname}.desktop $out/share/applications
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = with lib; {
    homepage = "https://pathplanner.dev/home.html";
    description = "A tool for creating autonomus paths for the First Robotics Compitition";
    license = with licenses; [ mit ];
  };
}
