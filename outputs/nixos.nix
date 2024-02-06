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
      ../system
      ../system/laptop/hardware.nix
      ../system/laptop/configuration.nix
    ];
  };

  desktop = nixosSystem {
    inherit pkgs system;
    specialArgs = {inherit inputs;};
    modules = [
      inputs.sops-nix.nixosModules.sops
      ../system
      ../system/desktop/hardware.nix
      ../system/desktop/configuration.nix
    ];
  };

  remote = nixosSystem {
    inherit pkgs system;
    specialArgs = {inherit inputs;};
    modules = [
      inputs.sops-nix.nixosModules.sops
      ../system
      ../system/remote/hardware.nix
      ../system/remote/configuration.nix
    ];
  };
}
