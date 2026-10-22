{ pkgs, ... }:

{
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
}
