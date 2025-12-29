{
  description = "TotalTaxAmount's NixOS and home-manager flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";

    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    aquamarine = {
      type = "git";
      url = "https://github.com/hyprwm/aquamarine";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprutils = {
      type = "git";
      url = "https://github.com/hyprwm/hyprutils";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
    };

    hyprland = {
      type = "git";
      submodules = true;
      url = "https://github.com/hyprwm/Hyprland";

      inputs.aquamarine.follows = "aquamarine";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprutils.follows = "hyprutils";
    };

    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcmojave-hyprcursor = {
      url = "github:libadoxon/mcmojave-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvml-tune = {
      url = "github:TotalTaxAmount/nvml-tune-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = # TODO: Use flake utils
    {
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      user = "totaltaxamount";

      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [ (import ./overlays) ];
      };
    in
    {
      homeConfigurations = import ./outputs/home.nix {
        inherit
          inputs
          system
          user
          pkgs
          ;
      };
      nixosConfigurations = import ./outputs/nixos.nix {
        inherit
          inputs
          system
          user
          pkgs
          ;
      };
      formatter.x86_64-linux = pkgs.nixfmt-tree;

      devShell.x86_64-linux = pkgs.mkShell {  # FIXME: Fix once flake utils is in use
        nativeBuildInputs = with pkgs; [
          nixfmt-tree
        ];
      };
    };
}
