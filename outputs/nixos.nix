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
    inherit pkgs system; # TODO fix!
    specialArgs = {inherit inputs;};
    modules = [
      ../modules/system/common
      ../modules/system/laptop/hardware.nix
      ../modules/system/laptop/configuration.nix
    ];
  };

  desktop = nixosSystem {
    inherit pkgs system;
    specialArgs = {inherit inputs;};
    modules = [
      inputs.sops-nix.nixosModules.sops
      ../modules/system/common
      ../modules/system/desktop/hardware.nix
      ../modules/system/desktop/configuration.nix
    ];
  };

  remote = nixosSystem {
    inherit pkgs system;
    specialArgs = {inherit inputs;};
    modules = [
      inputs.sops-nix.nixosModules.sops
      ../modules/system/common
      ../modules/system/remote/hardware.nix
      ../modules/system/remote/configuration.nix
    ];
  };
}
