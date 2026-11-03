{ config, pkgs, lib, ... }:

with lib;

{
  options.dotfiles.programs = {
    chess.enable = mkEnableOption "Enable chess game analyzer";
    steam.enable = mkEnableOption "Enable steam gaming platform";
    minecraft.enable = mkEnableOption "Enable minecraft game launcher";
  };
  config = let 
    user = config.dotfiles.user;
  in mkMerge [

    # --- chess --- #
    (mkIf config.dotfiles.programs.chess.enable {
      home-manager.users.${user}.home.packages = with pkgs; [
        chessx
        stockfish
      ];
    })

    # --- steam --- #
    (mkIf config.dotfiles.programs.steam.enable {
      programs = {
        steam.enable = true;
        gamemode.enable = true;
        gamescope.enable = true;
      };
    })

    # --- minecraft --- #
    (mkIf config.dotfiles.programs.minecraft.enable {
      home-manager.users.${user}.home.packages = with pkgs; [
        prismlauncher
      ];
    })

  ];
}
