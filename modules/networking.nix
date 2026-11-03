{ config, pkgs, lib, ... }:

with lib;

let 
  user = config.dotfiles.user;
in {
  options.dotfiles = {
    openssh.enable = mkEnableOption "Enable OpenSSH.";
    printing.enable = mkEnableOption "Enable printing.";
    bluetooth.enable = mkEnableOption "Enable bluetooth.";
  };
  config = mkMerge [
    {
      networking.networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      users.users.${user}.extraGroups = [ "networkmanager" ];  
    }

    # --- openssh --- #
    (mkIf config.dotfiles.openssh.enable {
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
      };
      networking.firewall.allowedTCPPorts = [ 22 ];
    })

    # --- printing --- #
    (mkIf config.dotfiles.printing.enable {
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
    })

    # --- bluetooth --- #
    (mkIf config.dotfiles.bluetooth.enable {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
        settings = {
          BR.IdleTimeout = 900;
          Policy.AutoEnable = false;
          General.Experimental = true;
        };
      };
      systemd.services.bluetooth.wantedBy = lib.mkForce [ ];
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
    })

  ];
}
