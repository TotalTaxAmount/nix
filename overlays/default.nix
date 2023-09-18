final: prev:
let 
  overlays = [
    (import ./apply)
  ];
in
prev.lib.composeManyExtensions overlays final prev