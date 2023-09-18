{inputs, system, user, ...}:

let 
  inherit (inputs.nixpkgs.lib) nixosSystem;

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ../overlays)
    ];
  };

in {
  laptop = nixosSystem {
    inherit pkgs system;
    specialArgs = {inherit inputs;};
    modules = [
      ../system/configuration.nix
      ../system/hosts/laptop.nix
    ];
  };
}