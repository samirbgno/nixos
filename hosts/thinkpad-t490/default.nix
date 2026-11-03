{ ... }:

{
  imports = [
    ./system.nix
    ./storage.nix
    ./hardware.nix
    ./software.nix
    
    ../../modules
  ];
}
