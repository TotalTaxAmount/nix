{ lib }:
with lib; rec {
  pow =
    let
      pow' = base: exponent: value:
        # FIXME: It will silently overflow on values > 2**62 :(
        # The value will become negative or zero in this case
        if exponent == 0
        then 1
        else if exponent <= 1
        then value
        else (pow' base (exponent - 1) (value * base));
    in base: exponent: pow' base exponent base;

  binToDec = v:
    let
      chars = stringToCharacters v;
      charsLen = length chars;
    in
      foldr
        (a: v: a + v)
        0
        (imap0
          (k: v: (toInt v) * (pow 2 (charsLen - k - 1)))
          chars);

  decToBin =
    let
      toBin' = q: a:
        if q > 0
        then (toBin'
          (q / 2)
          ((toString (mod q 2)) + a))
        else a;
    in
      v: toBin' v "";

  hexToDec = v:
    let
      hexToInt = {
        "0" = 0; "1" = 1;  "2" = 2;
        "3" = 3; "4" = 4;  "5" = 5;
        "6" = 6; "7" = 7;  "8" = 8;
        "9" = 9; "a" = 10; "b" = 11;
        "c" = 12;"d" = 13; "e" = 14;
        "f" = 15;
      };
      chars = stringToCharacters v;
      charsLen = length chars;
    in
      foldl
        (a: v: a + v)
        0
        (imap0
          (k: v: hexToInt."${v}" * (pow 16 (charsLen - k - 1)))
          chars);

  decToHex =
    let
      intToHex = [
        "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"
        "a" "b" "c" "d" "e" "f"
      ];
      toHex' = q: a:
        if q > 0
        then (toHex'
          (q / 16)
          ((elemAt intToHex (mod q 16)) + a))
        else a;
    in
      v: toHex' v "";
}