{
  description = "samir's nixos flake";

  outputs = inputs: {
    nixosConfigurations = {
      thinkpad-t490 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/thinkpad-t490 ];
      };
      workstation = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/workstation ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
  };
}
