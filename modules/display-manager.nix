{ config, pkgs, lib, ... }:

with lib;

{
  options.dotfiles.displayManager = mkOption {
    type = types.nullOr (types.enum [ "greetd" ]);
    default = null;
    description = "Display manager to use.";
  };
  config = let
    displayManager = config.dotfiles.displayManager;
  in mkMerge [

    # --- greetd --- #
    (mkIf (displayManager == "greetd") {
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings = {
          default_session = {
            user = "greeter";
            command = "${pkgs.tuigreet}/bin/tuigreet -c sway -w 50 -r --asterisks --theme action=black;button=black;border=white";
          };
        };
      };
    })

  ];
}
