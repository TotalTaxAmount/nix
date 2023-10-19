{inputs, system, user, ...}:

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

in {
  laptop = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inherit pkgs inputs user;
    };

    modules = [
      ../modules/home/common
      ../modules/home/laptop
    ];
  };

  remote = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inherit pkgs inputs user;
    };

    modules = [
      ../modules/home/common
      ../modules/home/remote
    ];
  }
}

