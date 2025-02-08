{
  config,
  pkgs,
  inputs,
  lib,
}:

let
  # Custom color themes
  customThemes = import ../theme/custom.nix;
  base16Themes = inputs.nix-colors.colorSchemes;

  # Flake stuff
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
  # https://gist.github.com/corpix/f761c82c9d6fdbc1b3846b37e1020e11 TODO: just source this gist
  pow =
    let
      pow' =
        base: exponent: value:
        # FIXME: It will silently overflow on values > 2**62 :(
        # The value will become negative or zero in this case
        if exponent == 0 then
          1
        else if exponent <= 1 then
          value
        else
          (pow' base (exponent - 1) (value * base));
    in
    base: exponent: pow' base exponent base;

  hexToDec =
    v:
    let
      hexToInt = {
        "0" = 0;
        "1" = 1;
        "2" = 2;
        "3" = 3;
        "4" = 4;
        "5" = 5;
        "6" = 6;
        "7" = 7;
        "8" = 8;
        "9" = 9;
        "a" = 10;
        "b" = 11;
        "c" = 12;
        "d" = 13;
        "e" = 14;
        "f" = 15;
      };
      chars = lib.stringToCharacters v;
      charsLen = lib.length chars;
    in
    lib.foldl (a: v: a + v) 0 (lib.imap0 (k: v: hexToInt."${v}" * (pow 16 (charsLen - k - 1))) chars);

  print-colors = pkgs.writeScriptBin "print_colors" ''
    #!${pkgs.bash}/bin/bash
    ${lib.concatMapStringsSep "\n"
      (
        color:
        let
          hexColor = config.colorScheme.palette."${color}";
          r = hexToDec (builtins.substring 0 2 hexColor);
          g = hexToDec (builtins.substring 2 2 hexColor);
          b = hexToDec (builtins.substring 4 2 hexColor);
        in
        ''
          echo -e "${color} = #${hexColor} \e[48;2;${toString r};${toString g};${toString b}m    \e[0m"
        ''
      )
      [
        "base00"
        "base01"
        "base02"
        "base03"
        "base04"
        "base05"
        "base06"
        "base07"
        "base08"
        "base09"
        "base0A"
        "base0B"
        "base0C"
        "base0D"
        "base0E"
        "base0F"
      ]
    }
  '';
in
{
  inherit
    customThemes
    base16Themes
    nix-colors-lib
    pow
    hexToDec
    print-colors
    ;
}
