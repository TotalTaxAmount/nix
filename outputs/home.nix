{inputs, system, ...}:

with inputs;

let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "qtwebkit-5.212.0-alpha4"
    ];
  };

  imports = [
  ];

  mkHome = {}: (
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit pkgs;
        inherit inputs;
      };

      modules = [
        {
          inherit imports;
        }
      ];

    }
  );
in {
  totaltax = mkHome {};
}

