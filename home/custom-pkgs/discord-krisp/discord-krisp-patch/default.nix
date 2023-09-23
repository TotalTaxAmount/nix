{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "discord-krisp-patch";
  version = "0.0.29"
  src = ./;

  installPhase = ''
    mkdir -p $out/bin

    substitute $src/${name}.sh $out/bin/${name} \
      --replace "#!/usr/bin/env nix-shell" "#!${pkgs.bash}/bin/bash" \
      --replace 'rizin_cmd="rizin"' "rizin_cmd=${pkgs.rizin}/bin/rizin" \
      --replace 'rz_find_cmd="rz-find"' "rz_find_cmd=${pkgs.rizin}/bin/rz-find" \
      --replace 'discord_version="0.0.28"' "discord_version=${version}"

    # cp $src/discord-krisp-patch.sh $out/bin/discord-krisp-patch

    chmod +x $out/bin/discord-krisp-patch
  '';
}