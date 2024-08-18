{
  inputs,
  system,
  user,
  ...
}:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
    overlays = [ (import ../overlays) ];
  };

in
{
  laptop = nixosSystem {
    inherit pkgs system; # TODO fix!
    specialArgs = {
      inherit inputs user;
    };
    modules = [
      ../modules/nixos/common
      ../modules/nixos/laptop/hardware.nix
      ../modules/nixos/laptop/configuration.nix
    ];
  };

  desktop = nixosSystem {
    inherit pkgs system;
    specialArgs = {
      inherit inputs user;
    };
    modules = [
      inputs.sops-nix.nixosModules.sops
      ../modules/nixos/common
      ../modules/nixos/desktop/hardware.nix
      ../modules/nixos/desktop/configuration.nix
    ];
  };

  remote = nixosSystem {
    inherit pkgs system;
    specialArgs = {
      inherit inputs;
    };
    modules = [
      inputs.sops-nix.nixosModules.sops
      ../modules/nixos/common
      ../modules/nixos/remote/hardware.nix
      ../modules/nixos/remote/configuration.nix
    ];
  };
}
