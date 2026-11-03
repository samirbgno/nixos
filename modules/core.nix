{ config, inputs, pkgs, lib, ... }:

with lib;

{
  options.dotfiles = {
    user = mkOption {
      type = types.str;
      default = "samir";
      description = "The username of the user.";
    };
    hostname = mkOption {
      type = types.str;
      default = "nixos";
      description = "The hostname of the machine.";
    };
    stateVersion = mkOption {
      type = types.str;
      default = "26.05";
      description = "The state version of the system.";
    };
  };

  config = let
    user = config.dotfiles.user;
    hostname = config.dotfiles.hostname;
  in {
    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      home = "/home/${user}/.dotfiles";
    };
    networking.hostName = hostname;

    programs.nix-ld.enable = true;

    services.xserver.xkb = {
      variant = "dvorak";
      options = "compose:ralt";
    };
    console.useXkbConfig = true;
    time.timeZone = "America/Santiago";
    documentation.nixos.enable = false;
    nix = {
      channel.enable = false;
      settings = {
        warn-dirty = false;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };
    home-manager.users.${user}.home.packages = with pkgs; [
      (writeShellScriptBin "nixos" ''
        FLAKE_DIR="/home/${user}/nixos"
        case "$1" in
          update)
            nix flake update --flake "$FLAKE_DIR"
            ;;
          switch)
            sudo nixos-rebuild switch --flake "$FLAKE_DIR"
            ;;
          *)
            echo "Usage: $0 {update|switch}"
            exit 1
            ;;
        esac
      '')
    ];
    security.sudo.extraRules = [{
      users = [ user ];
      commands = [{
        options = [ "NOPASSWD" ];
        command = "/run/current-system/sw/bin/nixos-rebuild";
      }];
    }];
    nixpkgs = {
      flake.setNixPath = true;
      config.allowUnfree = true;
      overlays = optionals (inputs ? nixpkgs-stable) [
        (final: prev: {
          stable = import inputs.nixpkgs-stable {
            config = config.nixpkgs.config;
            system = final.stdenv.hostPlatform.system;
          };
        })
      ];
    };
    system.stateVersion = config.dotfiles.stateVersion;
  };
}
