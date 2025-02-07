{
  inputs,
  ...
}:

{
  imports = [ inputs.nix-colors.homeManagerModule ];

  config = {
    colorScheme = inputs.nix-colors.colorSchemes.twilight;
  };
}
