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
      ../system
      ../system/hosts/laptop/hardware.nix
      ../system/hosts/laptop/configuration.nix
    ];
  };

  desktop = nixosSystem {
    inherit pkgs system;
    specialArgs = {inherit inputs;};
    modules = [
      ../system
      ../system/hosts/desktop/hardware.nix
      ../system/hosts/desktop/configuration.nix
    ];
  };
}