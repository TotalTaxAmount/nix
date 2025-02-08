{
  inputs,
  system,
  user,
  pkgs,
  ...
}:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
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
      ../nixos/common
      ../nixos/laptop/hardware.nix
      ../nixos/laptop/configuration.nix
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
      inputs.lanzaboote.nixosModules.lanzaboote
      
      ../nixos/common
      ../nixos/desktop/hardware.nix
      ../nixos/desktop/configuration.nix
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
      ../nixos/common
      ../nixos/remote/hardware.nix
      ../nixos/remote/configuration.nix
    ];
  };
}
