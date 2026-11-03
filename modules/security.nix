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
  home-manager.users.${user} = {
    home.packages = with pkgs; [ seahorse ];
    systemd.user.tmpfiles.rules = let
      keyring = builtins.replaceStrings [ "\n" ] [ "\\x0a" ] ''
        [keyring]
        display-name=${user}
        ctime=0
        mtime=0
        lock-on-idle=false
        lock-after=false
      '';
    in [
      "d %h/.local/share/keyrings 0700 - - -"
      "f %h/.local/share/keyrings/default 0600 - - - ${user}"
      "f %h/.local/share/keyrings/${user}.keyring 0600 - - - ${keyring}"
    ];
  };
}
