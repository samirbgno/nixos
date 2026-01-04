{
  outputs = inputs: {
    nixosConfigurations = {
      thinkpad-t490 = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [ ./hosts/thinkpad-t490.nix ];
        specialArgs = { inherit system inputs; };
      };
    };
    apps.x86_64-linux.default = let
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    in {
      type = "app";
      program = "${pkgs.writeShellScriptBin "install" (builtins.readFile ./install.sh)}/bin/install";
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
