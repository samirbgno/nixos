{ system, ... }:

{
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak-intl";
  };

  system.stateVersion = "25.11";
  documentation.nixos.enable = false;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs = {
    hostPlatform = system;
    config.allowUnfree = true;
  };
}
