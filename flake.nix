{
    description = "NixO & HomeManager config flake";
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = github:nix-community/home-manager;
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs :
    let 
        system = "x86_64-linux"; 
        user = "totaltaxamount";
    in {
        homeConfig = import ./outputs/home.nix {inherit inputs system user;};
        nixos = import ./outputs/nixos.nix {inherit inputs system user;};
    };
}