{inputs, system, ...}:

with inputs;

let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "qtwebkit-5.212.0-alpha4"
    ];
    overlays = [
      (import ../overlays)
    ];
  };

 

  mkHome = {}: (
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit pkgs inputs nixpkgs-lib;
      };

      modules = [
        ../home/home.nix
      ];

    }
  );
in {
  totaltax = mkHome {};
}

