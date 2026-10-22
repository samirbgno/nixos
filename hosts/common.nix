{ inputs, ... }:

{
  imports = [ ../modules/options.nix ];

  time.timeZone = "America/Santiago";
  documentation.nixos.enable = false;
  nix = {
    channel.enable = false;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  nixpkgs = {
    flake.setNixPath = true;
    config.allowUnfree = true;
    overlays = [
      (final: previous: {
        unstable = import inputs.nixpkgs-unstable {
          config = final.config;
          system = final.stdenv.hostPlatform.system;
        };
      })
    ];
  };
}
