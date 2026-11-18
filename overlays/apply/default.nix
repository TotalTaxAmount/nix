final: prev:

{
  lldb = prev.lldb.overrideAttrs {
    # https://github.com/NixOS/nixpkgs/issues/380196
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

  # patchelf 0.19.2 lays PT_DYNAMIC of the NVIDIA CLI binaries inside a
  # read-only, overlapping PT_LOAD. glibc's ld.so writes the DT_DEBUG pointer
  # there at startup, so nvidia-smi / nvidia-powerd / nvidia-cuda-mps-control
  # segfault in dl_main. Pin 0.15.2, which lays them out correctly.
  patchelf015 = prev.patchelf.overrideAttrs (old: rec {
    version = "0.15.2";
    src = prev.fetchurl {
      url = "https://github.com/NixOS/patchelf/releases/download/${version}/patchelf-${version}.tar.gz";
      hash = "sha256-DWn63A3rY/5GZlu9qZ6gIJy4G7PWDPVRCE+dvsB8u2w=";
    };
    doCheck = false;
  });

  # Rebuild a driver with the affected binaries re-patched from the pristine
  # origBin copies using the known-good patchelf.
  nvidiaDriverFixed = driver: driver.overrideAttrs (old: {
    postInstall =
      prev.lib.optionalString ((old.postInstall or null) != null) (old.postInstall + "\n")
      + ''
        for f in "$bin"/origBin/*; do
          name=$(basename "$f")
          [ -e "$bin/bin/$name" ] || continue
          rpath=$(${final.patchelf015}/bin/patchelf --print-rpath "$bin/bin/$name")
          install -m755 "$f" "$bin/bin/$name"
          ${final.patchelf015}/bin/patchelf \
            --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "$rpath" "$bin/bin/$name"
        done
      '';
  });

  libratbag = prev.libratbag.overrideAttrs (old : {
    postInstall = (old.postInstall or "") + ''
        FILE="$out/share/libratbag/glorious-model-o-wireless.device"

        if [ -f "$FILE" ]; then
          substituteInPlace "$FILE" --replace "DeviceMatch=usb:258a:201c;usb:258a:201d" "DeviceMatch=usb:258a:201c;usb:258a:201d;usb:258a:2011"
        fi
      '';
  });

  ## Wayland
  vscode = prev.vscode.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
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
    postInstall = (old.postInstall or "") + ''
      wrapProgram $out/bin/slack \
            --add-flags --enable-features=UseOzonePlatform
    '';
  });

  spotify = prev.spotify.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      wrapProgram $out/bin/spotify \
              --add-flags --enable-features=UseOzonePlatform \
              --add-flags --ozone-platform=wayland
    '';
  });
}
