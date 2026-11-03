{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./core.nix
    ./boot.nix
    ./games.nix
    ./tools.nix
    ./shells.nix
    ./editors.nix
    ./hacking.nix
    ./options.nix
    ./browsers.nix
    ./devtools.nix
    ./security.nix
    ./terminals.nix
    ./networking.nix
    ./home-manager.nix
    ./window-manager.nix
    ./virtualization.nix
    ./display-manager.nix
  ];
}
