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
      inherit inputs user system;
      host = "laptop";
    };
    modules = [
      inputs.chaotic.nixosModules.default
      ../modules/nixos/common
      ../modules/nixos/laptop/hardware.nix
      ../modules/nixos/laptop/configuration.nix
    ];
  };

  laptop-strix = nixosSystem {
    inherit pkgs system; # TODO fix!
    specialArgs = {
      inherit inputs user;
      host = "laptop-strix";
    };
    modules = [
      ../modules/nixos/common
      ../modules/nixos/laptop-strix/hardware.nix
      ../modules/nixos/laptop-strix/configuration.nix
    ];
  };

  desktop = nixosSystem {
    inherit pkgs system;
    specialArgs = {
      inherit inputs user;
      host = "desktop";
    };
    modules = [
      inputs.chaotic.nixosModules.default
      ../modules/nixos/common
      ../modules/nixos/desktop/hardware.nix
      ../modules/nixos/desktop/configuration.nix
    ];
  };

  remote = nixosSystem {
    inherit pkgs system;
    specialArgs = {
      inherit inputs;
      host = "remote";
    };
    modules = [
      inputs.sops-nix.nixosModules.sops
      ../modules/nixos/common
      ../modules/nixos/remote/hardware.nix
      ../modules/nixos/remote/configuration.nix
    ];
  };
}
