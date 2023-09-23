{
    description = "NixO & HomeManager config flake";
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";

        home-manager = {
            url = github:nix-community/home-manager;
            inputs.nixpkgs.follows = "nixpkgs";

        };

        hyprland-contrib = {
            url = "github:hyprwm/contrib";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        spicetify-nix.url = github:the-argus/spicetify-nix;

        nix-colors.url = github:misterio77/nix-colors;

        nix-gaming.url = github:fufexan/nix-gaming;
    };

    outputs = {self, nixpkgs, home-manager, ...}@inputs :
    let 
        system = "x86_64-linux"; 
        user = "totaltaxamount";
    in {
        homeConfigurations = import ./outputs/home.nix {inherit inputs system user;};
        nixosConfigurations = import ./outputs/nixos.nix {inherit inputs system user;};
    };
}