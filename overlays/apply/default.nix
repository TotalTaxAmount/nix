final: prev:

{
  lldb = prev.lldb.overrideAttrs { # https://github.com/NixOS/nixpkgs/issues/380196 
    dontCheckForBrokenSymlinks = true;
  };

  qemu-patched = prev.qemu.overrideAttrs (old: {
    src = prev.fetchurl {
      url = "https://download.qemu.org/qemu-8.2.0.tar.xz";
      hash = "sha256-vwDS+hIBDfiwrekzcd71jmMssypr/cX1oP+Oah+xvzI=";
    };
    patches = (
      (old.patches or [ ])
      ++ [
        (prev.fetchurl {
          url = "https://raw.githubusercontent.com/zhaodice/qemu-anti-detection/496124b175716f99edac49a37012f5b55946a76e/qemu-8.2.0.patch";
          hash = "sha256-zCF/eb8quODgcNC3Rpcf2zQcriWoTzYTnprCSbh98yo=";
        })
      ]
    );
  });

  xplorer = prev.xplorer.overrideAttrs (old: {
    postInstall =
      old.postInstall
      + ''
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

  xwaylandvideobridge = prev.xwaylandvideobridge.overrideAttrs (old: {
    # patches = [
    #   ./patches/xwaylandvideobridge_hyprland.patch
    # ];
  });

  audacity = prev.audacity.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + "wrapProgram $out/bin/audacity --set GDK_BACKEND x11 --set UBUNTU_MENUPROXY 0";
  });

  ## Wayland
  vscode = prev.vscode.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        wrapProgram $out/bin/code \
              --add-flags --enable-features=UseOzonePlatform,WaylandWindowDecorations \
              --add-flags --ozone-platform-hint=auto'';
  });

  bitwarden-desktop = prev.bitwarden-desktop.overrideAttrs (old: {
    desktopItems = [
      (prev.makeDesktopItem {
        name = "bitwarden";
        exec = "bitwarden --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto %U";
        comment = "Secure and free password manager for all of your devices";
        desktopName = "Bitwarden";
        categories = [ "Utility" ];
        mimeTypes = [ "x-scheme-handler/bitwarden" ];
      })
    ];
  });

  slack = prev.slack.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        wrapProgram $out/bin/slack \
              --add-flags --enable-features=UseOzonePlatform
      '';
  });

  spotify = prev.spotify.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        wrapProgram $out/bin/spotify \
                --add-flags --enable-features=UseOzonePlatform \
                --add-flags --ozone-platform=wayland
      '';
  });

  obsidian = prev.obsidian.overrideAttrs (old: {
    postInstall = 
      (old.postInstall or "")
      + ''
        wrapProgram $out/bin/obsidian \
                --add-flags --no-sandbox \
                --add-flags --ozone-platform=wayland \
                --add-flags --ozone-platform-hint=auto \
                --add-flags --enable-features=UseOzonePlatform,WaylandWindowDecorations 
      '';
  });
}
