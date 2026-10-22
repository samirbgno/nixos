{ inputs, ... }:

{
  imports = [ inputs.disko.nixosModules.disko ];

  services.btrbk.instances.local = {
    onCalendar = "daily";    
    settings = {
      snapshot_preserve_min = "latest";
      snapshot_preserve = "7d 4w 0m 0y";
      volume = {
        "/" = {
          snapshot_dir = "/.snapshots";
          subvolume.home.snapshot_name = "home";
        };
      };
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };
  swapDevices = [{
    size = 24 * 1024;
    device = "/swapfile";
  }];

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1G";
          type = "EF00";
          content = {
            format = "vfat";
            type = "filesystem";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            settings.allowDiscards = true;
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd:3" "noatime" ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd:3" "noatime" ];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd:3" "noatime" ];
                };
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [ "compress=zstd:3" "noatime" ];
                };
                "@snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = [ "compress=zstd:3" "noatime" ];
                };
                "@vm" = {
                  mountpoint = "/var/lib/libvirt";
                  mountOptions = [ "noatime" "nodatacow" ];
                };
                "@containers" = {
                  mountpoint = "/var/lib/containers";
                  mountOptions = [ "noatime" "nodatacow" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
