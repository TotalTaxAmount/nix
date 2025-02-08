{
  inputs,
  system,
  user,
  pkgs,
  ...
}:

with inputs;
{
  laptop = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inherit
        pkgs
        inputs
        user
        system
        ;
      host = "laptop";
    };

    modules = [
      ../home-manager/common
      ../home-manager/laptop
    ];
  };

  remote = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inherit
        pkgs
        inputs
        user
        system
        ;
    };

    modules = [
      ../home-manager/common
      ../home-manager/remote
    ];
  };

  desktop = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inherit
        pkgs
        inputs
        user
        system
        ;
      host = "desktop";
    };

    modules = [
      ../home-manager/common
      ../home-manager/desktop
    ];
  };
}
