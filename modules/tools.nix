{ config, pkgs, lib, ... }:

let 
  user = config.dotfiles.user;
in {
  services.gvfs.enable = true;
  programs.thunar.enable = true;
  services.tumbler.enable = true;
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    package = pkgs.unstable.immich;
  };
  environment.systemPackages = [ pkgs.bindfs ];
  fileSystems."home/${user}/photos" = {
    fsType = "fuse.bindfs";
    device = "/var/lib/immich/library";
    options = [
      "noauto"
      "perms=0700"
      "allow_other"
      "force-group=users"
      "force-user=${user}"
      "x-systemd.automount"
    ];
  };
  systemd = {
    targets.postgresql-setup.wantedBy = lib.mkForce [ ];
    services = {
      immich-server = {
        wantedBy = lib.mkForce [ ];
        serviceConfig.StopIdleSec = 900;
      };
      postgresql = {
        wantedBy = lib.mkForce [ ];
        serviceConfig.StopIdleSec = 900;
      };
      redis-immich = {
        wantedBy = lib.mkForce [ ];
        serviceConfig.StopIdleSec = 900;
      };
      immich-machine-learning = {
        wantedBy = lib.mkForce [ ];
        serviceConfig.StopIdleSec = 900;
      };
    };
  };
  security.sudo.extraRules = [
    {
      users = [ user ]; 
      commands = [
        { 
          options = [ "NOPASSWD" ]; 
          command = "/run/current-system/sw/bin/systemctl stop immich-server immich-machine-learning redis-immich postgresql"; 
        }
        { 
          options = [ "NOPASSWD" ]; 
          command = "/run/current-system/sw/bin/systemctl start postgresql redis-immich immich-machine-learning immich-server"; 
        }
      ];
    }
  ];
  networking.firewall.allowedTCPPorts = [ 2283 ];
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      zip
      unzip
      rar

      mpv
      tree
      swayimg
      libheif
      zathura

      fwupd
      exfatprogs
      efibootmgr

      (writeShellScriptBin "open-thunar" ''
        if [ "$#" -eq 0 ]; then
          exec thunar /home/${user}
        else
          exec thunar "$@"
        fi
      '')

      (writeShellScriptBin "immich" ''
        sudo systemctl start postgresql redis-immich immich-machine-learning immich-server
        until ${pkgs.curl}/bin/curl -s http://localhost:2283 > /dev/null; do
          sleep 0.5
        done
        ${pkgs.google-chrome}/bin/google-chrome \
          --app=http://localhost:2283 \
          --user-data-dir="$HOME/.config/immich-app-profile"
      '')
    ];
    xdg.desktopEntries = {
      thunar = {
        name = "Thunar";
        icon = "thunar";
        exec = "open-thunar %U";
      };
      thunar-settings = {
        noDisplay = true;
        name = "thunar preferences";
      };
      thunar-bulk-rename = {
        noDisplay = true;
        name = "bulk rename";
      };
      immich = {
        name = "Immich";
        exec = "immich";
        icon = "org.gnome.Photos";
      };
    };
  };
}
