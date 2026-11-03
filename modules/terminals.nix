{ config, ... }:

let 
  user = config.dotfiles.user;
  font = config.dotfiles.font;
in {
  home-manager.users.${user} = {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          pad = "12x12";
          resize-delay-ms = 12;
          font = "${font}:size=12";
        };
        colors-dark = {
          foreground = "ffffff";
          background = "000000";
        };
        cursor = {
          blink = "yes";
          style = "beam";
          unfocused-style = "none";
        };
        scrollback = {
          lines = 10000;
          indicator-position = "none";
        };
      };
    };
    xdg.desktopEntries = {
      foot = {
        noDisplay = true;
        name = "foot";
      };
      footclient = {
        noDisplay = true;
        name = "foot client";
      };
      foot-server = {
        noDisplay = true;
        name = "foot server";
      };
    };
  };
}
