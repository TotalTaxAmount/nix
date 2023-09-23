{ lib, builtins }:

let
  hexToRGB = hexColor: 
    let
      red = builtins.parseInt (builtins.substring hexColor 1 2) 16;
      green = builtins.parseInt (builtins.substring hexColor 3 4) 16;
      blue = builtins.parseInt (builtins.substring hexColor 5 6) 16;
    in
      "${red},${green},${blue}";

in
{
  # Example usage:
  hexColorToRGB = hexToRGB "#FFA500"; # Example hex color (orange)
}
