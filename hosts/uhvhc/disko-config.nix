{ inputs, lib, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
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
            };
          };
          zfs = {
            name = "zfs";
            size = "100%";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
        };
      };
    };

    zpool.rpool = {
      type = "zpool";
      rootFsOptions = {
        mountpoint = "none";
        canmount = "off";
        compression = "zstd";
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "prompt";
      };
      options = {
        ashift = "12";
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
