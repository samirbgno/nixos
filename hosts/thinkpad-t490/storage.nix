{ inputs, ... }:

{
  imports = [ inputs.disko.nixosModules.disko ];

  services = {
    fstrim.enable = true;
    btrfs.autoScrub.enable = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  disko.devices = {
    disk.main = {
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
              name = "cryptlvm";
              settings.allowDiscards = true;
              passwordFile = "/tmp/luks.key";
              content = {
                vg = "pool";
                type = "lvm_pv";
              };
            };
          };
        };
      };
    };
    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = "32G";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };
        root = {
          size = "100%FREE";
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
            };
          };
        };
      };
    };
  };
}
