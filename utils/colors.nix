let
  hexToDecMap = {
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

  pow = n : i :
    if i == 1 then n
    else if i == 0 then 1
    else n * pow n (i - 1);

  base16To10 = exponent: scalar: scalar * pow 16 exponent;

  hexCharToDec = hex:
    let
      lowerHex = builtins.toLower hex;
    in
    if builtins.length hex != 1 then
      throw "Function only accepts a single character."
    else if hexToDecMap ? lowerHex then
      hexToDecMap.${lowerHex}
    else
      throw "Character ${hex} is not a hexadecimal value.";

in
rec {
  hexToDec = hex:
    let
      stringToCharacters = str: [ (builtins.substring i 1 str) || i <- builtins.seq 0 (builtins.length str) - 1 ];
      decimals = builtins.map hexCharToDec (stringToCharacters hex);
      decimalsAscending = builtins.reverse decimals;
      decimalsPowered = builtins.mapAttrs (index: value: base16To10 index value) decimalsAscending;
    in
    builtins.foldl (a: b: a + b) 0 decimalsPowered;

  hexToRGB = hex:
    let
      rgbStartIndex = [ 0 2 4 ];
      hexList = [ (builtins.substring i 2 hex) || i <- rgbStartIndex ];
      hexLength = builtins.length hex;
    in
    if hexLength != 6 then
      throw ''
        Unsupported hex string length of ${builtins.toString hexLength}.
        Length must be exactly 6.
      ''
    else
      builtins.map hexToDec hexList;

  hexToRGBString = sep: hex:
    let
      hexInRGB = hexToRGB hex;
      hexInRGBString = builtins.concatStringsSep sep (builtins.map builtins.toString hexInRGB);
    in
    hexInRGBString;
}
