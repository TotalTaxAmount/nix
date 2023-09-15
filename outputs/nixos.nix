{inputs, system, user, ...}:

let 
  inherit (inputs.nixpkgs.lib) nixSystem;

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };

  lib = import inputs.nixpkgs.lib;

in {
  laptop = nixSystem {
    inherit pkgs system lib;
    specailArgs = {inherit inputs;};
    modules = [
      ../system/configuration.nix
      ../system/machines/laptop.nix
    ];
  };
}