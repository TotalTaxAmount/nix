{
    description = "TotalTaxAmount's NixOS and home-manager flake";
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

        spicetify-nix ={
            url = github:the-argus/spicetify-nix;
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-colors = {
            url = github:misterio77/nix-colors;
        };

#        nix-gaming = {
 #           url = github:fufexan/nix-gaming;
  #          inputs.nixpkgs.follows = "nixpkgs";
   #     };

        sops-nix = {
            url = github:Mic92/sops-nix;
            inputs.nixpkgs.follows = "nixpkgs";
        };

	    # vscode-server.url = github:nix-community/nixos-vscode-server;
    };

    outputs = {self, nixpkgs, home-manager, sops-nix, ...}@inputs :
    let 
        system = "x86_64-linux"; 
        user = "totaltaxamount";
    in {
        homeConfigurations = import ./outputs/home.nix {inherit inputs system user;};
        nixosConfigurations = import ./outputs/nixos.nix {inherit inputs system user;};
        formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    };
}
