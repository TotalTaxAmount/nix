{ lib, stdenvNoCC, fetchFromGitHub, autoreconfHook, gtk3, gnome, gnome-icon-theme, hicolor-icon-theme}:


stdenvNoCC.mkDerivation rec {
    name = "candy-icons";
    version = "1.0.0";

    src = fetchFromGitHub {
        owner = "EliverLara";
        repo = name;
        rev = "1c5b81a3fcec1ffe62828c168c43f4cb6ce71e40";
        hash = "sha256-B62VpI77Jkug7nyUSUN8/dizKzZDve8kr5Po80HfNgE=";
    };

    nativeBuildInputs = [
        gtk3
        autoreconfHook
    ];

    propagatedBuildInputs = [
        gnome.adwaita-icon-theme
        gnome-icon-theme
        hicolor-icon-theme
    ];

    dontDropIconThemeCache = true;

    phases = [ "install" ];

    installPhase = ''
        mkdir -p $out/share/icons
        cp -r $src/* $out/share/icons/
    '';

    postFixup = ''
       gtk-update-icon-cache "$out"/share/icons/
    '';

    meta = with lib; {
        description = "An icon theme colored with sweet gradients";
        homepage = "https://www.opendesktop.org/p/1305251/";
        license = with licenses; [ gpl3 ];
        platforms = platforms.linux;
        maintainers = with maintainers; [ totaltaxamount ];
    };
}