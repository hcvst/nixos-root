{ inputs, lib, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk = {
      disk1 = {
        device = lib.mkDefault "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B07_S63CNX0Y715016";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              name = "zfs1";
              size = "100%";
              content = { type = "zfs"; pool = "rpool"; };
            };
          };
        };
      };

      disk2 = {
        device = lib.mkDefault "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B07_S63CNX0Y715029"; 
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              name = "ESP2";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot-fallback";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              name = "zfs2";
              size = "100%";
              content = { type = "zfs"; pool = "rpool"; };
            };
          };
        };
      };
    };

    zpool.rpool = {
      type = "zpool";
      mode = "mirror";
      rootFsOptions = {
        mountpoint = "none";
        canmount = "off";
        compression = "zstd";
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "prompt";
      };
      options = {
        ashift = "12"; # confirm via physical_block_size on both disks
        autotrim = "on";
      };

      datasets = {
        "local/root" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/";
          postCreateHook = "zfs snapshot rpool/local/root@blank";
        };
        "local/nix" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/nix";
        };
        "local/home" = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/home";
          postCreateHook = "zfs snapshot rpool/local/home@blank";
        };
        "safe/persist" = {
          type = "zfs_fs";
          options = {
            mountpoint = "legacy";
            "com.sun:auto-snapshot" = "true";
          };
          mountpoint = "/persist";
        };
      };
    };
  };
}