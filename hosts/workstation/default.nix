{ ... }:

{
  imports = [
    ./system.nix
    ./storage.nix
    ./hardware.nix
    ./software.nix

    ../../modules/boot.nix
    ../../modules/core.nix
    ../../modules/home-manager.nix
    ../../modules/networking.nix
    ../../modules/devtools.nix
    ../../modules/shells.nix
    ../../modules/editors.nix
  ];
}
