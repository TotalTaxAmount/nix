{pkgs, config, inputs, ...}:

let

in {
  imports = [
    inputs.nix-colors.homeManagerModule
  ];

  config = {
    colorScheme = inputs.nix-colors.colorSchemes.twilight;

    home.packages = with pkgs; [
      
    ];
  };
}
