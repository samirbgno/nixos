{ config, pkgs, ... }:

let 
  user = config.dotfiles.user;
in {
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      burpsuite
    ];
    xdg.desktopEntries = {
      burpsuite = {
        exec = "burpsuite";
        icon = "burpsuite";
        name = "Burp Suite";
      };
    };
  };
}
