{ config, pkgs, lib, ... }:

with lib;

{
  options.dotfiles.programs = {
    thunar.enable = mkEnableOption "Enable thunar file manager";
    immich.enable = mkEnableOption "Enable immich photo manager";
  };

  config = let
    user = config.dotfiles.user;
  in mkMerge [
    {
      networking.firewall.allowedTCPPorts = [
        4321
        8788
        53317
      ];
      home-manager.users.${user} = {
        home.packages = with pkgs; [
          zip
          unzip
          rar
          p7zip

          mpv
          tree
          swayimg
          zathura

          fwupd
          efibootmgr

          pavucontrol

          sigil
          bruno
          discord
          lazydocker
          localsend
          libreoffice
        ];
      };
    }

    # --- thunar --- #
    (mkIf config.dotfiles.programs.thunar.enable {
      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-volman
          thunar-archive-plugin
        ];
      };
      services = {
        gvfs.enable = true;
        tumbler.enable = true;
      };
      home-manager.users.${user} = {
        home.packages = with pkgs; [
          libheif
          xarchiver
          exfatprogs
          ffmpegthumbnailer
          (writeShellScriptBin "open-thunar" ''
            if [ "$#" -eq 0 ]; then
              exec thunar /home/${user}
            else
              exec thunar "$@"
            fi
          '')
        ];
        xdg.desktopEntries = {
          thunar = {
            name = "Thunar";
            icon = "thunar";
            exec = "open-thunar %U";
          };
          thunar-bulk-rename = {
            noDisplay = true;
            name = "bulk rename";
          };
          thunar-settings = {
            noDisplay = true;
            name = "thunar preferences";
          };
        };
      };
    })

    # --- immich --- #
    (mkIf config.dotfiles.programs.immich.enable {
      services.immich = {
        enable = true;
        host = "0.0.0.0";
      };
      #environment.systemPackages = [ pkgs.bindfs ];
      #fileSystems."home/${user}/photos" = {
      #  fsType = "fuse.bindfs";
      #  device = "/var/lib/immich/library";
      #  options = [
      #    "noauto"
      #    "perms=0700"
      #    "allow_other"
      #    "force-group=users"
      #    "force-user=${user}"
      #    "x-systemd.automount"
      #  ];
      #};
      systemd = {
        #tmpfiles.rules = [
        #  "d /var/lib/immich/library 0750 immich immich - -"
        #  "d /home/${user}/photos 0700 ${user} users - -"
        #];
        targets.postgresql-setup.wantedBy = mkForce [ ];
        services = {
          immich-server = {
            wantedBy = mkForce [ ];
            serviceConfig.StopIdleSec = 900;
          };
          postgresql = {
            wantedBy = mkForce [ ];
            serviceConfig.StopIdleSec = 900;
          };
          redis-immich = {
            wantedBy = mkForce [ ];
            serviceConfig.StopIdleSec = 900;
          };
          immich-machine-learning = {
            wantedBy = mkForce [ ];
            serviceConfig.StopIdleSec = 900;
          };
        };
      };
      security.sudo.extraRules = [{
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
      }];
      networking.firewall.allowedTCPPorts = [ 2283 ];
      home-manager.users.${user} = {
        home.packages = with pkgs; [
          (writeShellScriptBin "immich" ''
            sudo systemctl start postgresql redis-immich immich-machine-learning immich-server
            until ${pkgs.curl}/bin/curl -s http://localhost:2283 > /dev/null; do
              sleep 0.5
            done
            ${pkgs.google-chrome}/bin/google-chrome \
              --app=http://localhost:2283 \
              --user-data-dir="$HOME/.config/immich-app-profile"
          '')
          (writeShellScriptBin "immich-backup" ''
            DATE=$(${pkgs.coreutils}/bin/date +%Y%m%d_%H%M%S)
            sudo ${pkgs.gnutar}/bin/tar \
              --use-compress-program="${pkgs.zstd}/bin/zstd" \
              -cf "immich-backup-$DATE.tar.zst" \
              --exclude='thumbs' \
              --exclude='encoded-video' \
              -C /var/lib/immich .
            echo "Done."
          '')
        ];
        xdg.desktopEntries = {
          immich = {
            name = "Immich";
            exec = "immich";
            icon = "org.gnome.Photos";
          };
        };
      };
    })

  ];
}
