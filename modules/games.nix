{ config, pkgs, ... }:

let 
  user = config.dotfiles.user;
in {
  hardware.graphics.enable32Bit = true;
  programs = {
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
  };
  home-manager.users.${user}.home.packages = with pkgs; [
    chessx
    stockfish
    prismlauncher
  ];
}
