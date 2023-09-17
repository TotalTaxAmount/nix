{
    description = "NixO & HomeManager config flake";
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";

        home-manager = {
            url = github:nix-community/home-manager;
            inputs.nixpkgs.follows = "nixpkgs";

        };
        nix-colors.url = github:misterio77/nix-colors;

        spicetify-nix.url = github:the-argus/spicetify-nix;
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