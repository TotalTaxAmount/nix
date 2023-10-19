{ lib
, stdenv
, fetchFromGitHub
, python311Packages
, glib
, gtk3
, gobject-introspection
, libwnck
, wrapGAppsHook
}:


python311Packages.buildPythonPackage rec {
    name = "SysMonTask";
    version = "1.0.0";

    src = fetchFromGitHub {
        owner = "KrispyCamel4u";
        repo = "SysMonTask";
        rev = "aee8b9cace49df622909b280010ea08c952198c5";
        sha256 = "sha256-N6PxcuSL+GQHPQ4YN+hN7lFmDrDbDYBDdcAVAqdDdWM=";
    };

    doCheck = false;

    prePatch = ''
        substituteInPlace setup.py --replace "version='1.x.x'" "version='1.0.0'"

        substituteInPlace sysmontask/sysmontask.py --replace "/usr/share/sysmontask/" "$out/usr/share/sysmontask/"
        
        # Wayland icon moment (GTK!!)
        substituteInPlace sysmontask/gproc.py --replace "icon_theme=g.IconTheme().get_default()" "
        g.init([])
        icon_theme=g.IconTheme.get_for_screen(g.Window().get_display().get_default().get_default_screen())"
    '';

    nativeBuildInputs = [
        glib
        python311Packages.setuptools
        wrapGAppsHook
        gobject-introspection

    ];

    propagatedBuildInputs = [
        python311Packages.psutil
        python311Packages.pycairo
        python311Packages.pygobject3
        gtk3
        libwnck
    ];

    postInstall = ''
        mkdir -p $out/usr/share
        cp -r $out/lib/python3.11/site-packages/usr/share/* $out/usr/share/


        glib-compile-schemas $out/usr/share/glib-2.0/schemas
        '';


     meta = with lib; {
        description = "SysMonTask is a windows task manager clone for linux";
        license = licenses.gpl3;
        maintainers = [ maintainers.totaltaxamount ];
    };


}
