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
    inherit pkgs system user;
    specialArgs = {inherit inputs;};
    modules = [
      ../hosts
      ../hosts/laptop/hardware.nix
      ../hosts/laptop/configuration.nix
    ];
  };

  desktop = nixosSystem {
    inherit pkgs system user;
    specialArgs = {inherit inputs;};
    modules = [
      inputs.sops-nix.nixosModules.sops
      ../hosts
      ../hosts/desktop/hardware.nix
      ../hosts/desktop/configuration.nix
    ];
  };

  remote = nixosSystem {
    inherit pkgs system user;
    specialArgs = {inherit inputs;};
    modules = [
      inputs.sops-nix.nixosModules.sops
      ../hosts
      ../hosts/remote/hardware.nix
      ../hosts/remote/configuration.nix
    ];
  };
}
