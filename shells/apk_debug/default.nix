{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs; [ 
        dex2jar
        apktool
        jd-gui
        unzip
        openjdk8-bootstrap
        jadx
        android-studio
     ];
}