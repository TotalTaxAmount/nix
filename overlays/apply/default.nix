final: prev:

{
  discord = prev.discord.override { withVencord = true; };
  # btop = prev.btop.overrideAttrs (old: {
  #   src = prev.fetchFromGitHub {
  #     owner = "romner-set";
  #     repo = "btop-gpu";
  #     rev = "2378dd4a96883205729879df217f862280129ad0";
  #     hash = "sha256-5Xe13O0FL70V9O72KhuLbaAPo0DaKL9XXWJoAj0YEQY=";
  #   };

  #   buildInputs = old.buildInputs ++ [ prev.fmt prev.makeWrapper ];

  #   postInstall = ''
  #     wrapProgram $out/bin/btop --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
  #   '';
  # });

  qemu-patched = prev.qemu.overrideAttrs (old: {
    src = prev.fetchurl {
      url = "https://download.qemu.org/qemu-8.2.0.tar.xz";
      hash = "sha256-vwDS+hIBDfiwrekzcd71jmMssypr/cX1oP+Oah+xvzI=";
    };
    patches = ((old.patches or [ ]) ++ [
      (prev.fetchurl {
        url =
          "https://raw.githubusercontent.com/zhaodice/qemu-anti-detection/496124b175716f99edac49a37012f5b55946a76e/qemu-8.2.0.patch";
        hash = "sha256-zCF/eb8quODgcNC3Rpcf2zQcriWoTzYTnprCSbh98yo=";
      })
    ]);
  });

  xplorer = prev.xplorer.overrideAttrs (old: {
    postInstall = old.postInstall + ''
      mkdir -p $out/share/applications
      echo "
        [Desktop Entry]
        Type=Application
        Version=1.0
        Name=Xplorer
        Path=$out/bin
        Exec=xplorer
        Icon=$src/src/Icon/icon.png
      " >> $out/share/applications/xplorer.desktop
    '';

    patches = (old.patches or [ ]) ++ [ ./patches/xplorer_json_storage.patch ];
  });

  xwaylandvideobridge = prev.xwaylandvideobridge.overrideAttrs (old:
    {
      # patches = [
      #   ./patches/xwaylandvideobridge_hyprland.patch
      # ];
    });

  audacity = prev.audacity.overrideAttrs (old: {
    postInstall = (old.postInstall or "")
      + "wrapProgram $out/bin/audacity --set GDK_BACKEND x11 --set UBUNTU_MENUPROXY 0";
  });
}
