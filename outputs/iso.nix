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
  iso = nixosSystem {
    inherit pkgs system;
    specialArgs = {inherit inputs;};
    modules = [
      (pkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      ../modules/nixos/common
      ../modules/home-manager/common
    ];
  };
}
