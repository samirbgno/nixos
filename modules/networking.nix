{ config, pkgs, lib, ... }:

let 
  user = config.dotfiles.user;
in {
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  users.users.${user}.extraGroups = [ "networkmanager" ];

  systemd.services.bluetooth.wantedBy = lib.mkForce [ ];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      BR.IdleTimeout = 900;
      Policy.AutoEnable = false;
      General.Experimental = true;
    };
  };
  home-manager.users.${user} = {
    home.packages = with pkgs; [ blueman ];
    xdg.desktopEntries = {
      blueman-manager = {
        name = "Blueman";
        icon = "blueman";
        exec = "blueman-manager";
        settings.StartupNotify = "true";
      };
      blueman-adapters = {
        noDisplay = true;
        name = "bluetooth adapters";
      };
    };
  };

  hardware.sane.enable = true;
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
        gutenprint
      ];
    };
  };
}
