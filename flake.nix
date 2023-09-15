{
    description = "NixO & HomeManager config flake";
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = github:nix-community/home-manager;
            inputs.nixpkgs.follows = "nixpkgs";

        };
    };

    outputs = {self, nix, ...}@inputs :
    let 
        system = "x86_64-linux"; 
        user = "totaltaxamount";
    in {
        homeConfigurations = import ./outputs/home.nix {inherit inputs system user;};
        nixosConfigurations = import ./outputs/nixos.nix {inherit inputs system user;};
    };
}