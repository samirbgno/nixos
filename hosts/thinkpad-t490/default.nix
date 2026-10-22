{ ... }:

{
  imports = [
    ../common.nix
    ./storage.nix
    ./hardware.nix
    ./software.nix
    
    ../../modules
  ];

  networking.hostName = "thinkchad";
  dotfiles = {
    monitors = {
      devices = {
        mon1 = {
          name = "eDP-1";
          mode = "1920x1080@60Hz";  
        };
        mon2 = {
          name = "DP-5";
          mode = "1920x1080@144Hz";
        };
      };
      profiles = {
        undocked = [
          {
            monitor = "mon1";
            workspaces = [ "1" "2" "3" "4" "5" "6" "7" "8" ];
          }
        ];
        docked = [
          {
            monitor = "mon2";
            position = "0,0";
            workspaces = [ "1" "2" "3" "4" ];
          }
          {
            monitor = "mon1";
            position = "0,1080";
            workspaces = [ "5" "6" "7" "8" ];
          }
        ];
      };
    };
  };
  system.stateVersion = "25.11";
}
