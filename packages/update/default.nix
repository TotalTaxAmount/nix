{
  writeShellApplication,
  coreutils,
  findutils,
  gnugrep,
  gnused,
  git,
  lixPackageSets,
  nixos-rebuild,
  nix-output-monitor,
}:

writeShellApplication {
  name = "update";
  runtimeInputs = [
    coreutils
    findutils
    gnugrep
    gnused
    git
    lixPackageSets.stable.lix
    nixos-rebuild
    nix-output-monitor
  ];
  text = builtins.readFile ./build.sh;
}
