{ lib, pkgs, ... }:

with lib;

{
  options.dotfiles = {
    font = mkOption {
      type = types.str;
      default = "BlexMono Nerd Font";
      description = "Font name.";
    };
    fontPackage = mkOption {
      type = types.package;
      default = pkgs.nerd-fonts.blex-mono;
      description = "Font package.";
    };
    monitors = {
      devices = mkOption {
        default = { };
        type = types.attrsOf (
          types.submodule {
            options = {
              name = mkOption {
                description = "Output name.";
                example = "eDP-1";
                type = types.str;
              };
              mode = mkOption {
                description = "Resolution and refresh rate.";
                example = "1920x1080@60Hz";
                type = types.str;
              };
            };
          }
        );
      };
      profiles = mkOption {
        default = { };
        type = types.attrsOf (
          types.listOf (
            types.submodule {
              options = {
                monitor = mkOption {
                  description = "Monitor name.";
                  type = types.str;
                };
                position = mkOption {
                  description = "X,Y layout coordinates.";
                  example = "0,0";
                  type = types.nullOr types.str;
                };
                workspaces = mkOption {
                  description = "Assigned workspaces.";
                  default = [ ];
                  type = types.listOf types.str;
                };
              };
            }
          )
        );
      };
    };
  };
}
