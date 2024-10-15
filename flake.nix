{
  description = "TotalTaxAmount's NixOS and home-manager flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";

    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
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

    hyprland = {
      # url = "github:hyprwm/Hyprland?ref=v0.41.2&submodules=1";
      type = "git";
      submodules = true;
      url = "https://github.com/hyprwm/Hyprland";
      # rev = "e5ff19ac0f2c8d53a0c847d06a17676e636d6447";

      inputs.aquamarine.follows = "aquamarine";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprsplit = {
    #   type = "git";
    #   url = "https://github.com/shezdy/hyprsplit";
    #   # ref = "refs/tags/v0.41.2";

    #   inputs.hyprland.follows = "hyprland";
    # };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; 
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #        nix-gaming = {
    #           url = github:fufexan/nix-gaming;
    #          inputs.nixpkgs.follows = "nixpkgs";
    #     };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcmojave-hyprcursor = {
      url = "github:libadoxon/mcmojave-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # vscode-server.url = github:nix-community/nixos-vscode-server;
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      user = "totaltaxamount";
    in
    {
      homeConfigurations = import ./outputs/home.nix { inherit inputs system user; };
      nixosConfigurations = import ./outputs/nixos.nix { inherit inputs system user; };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
