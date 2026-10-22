{ config, pkgs, ... }:

let 
  user = config.dotfiles.user;
in {
  services = {
    fprintd.enable = true;
    dbus.implementation = "broker";
    gnome.gnome-keyring.enable = true;
    getty = {
      autologinUser = user;
      extraArgs = [
        "--noissue"
        "--skip-login"
      ];
    };
  };
  home-manager.users.${user}.home = {
    packages = with pkgs; [ seahorse ];
    file.".local/share/keyrings/default".text = "login";
  };
}
