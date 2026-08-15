# hosts/<hostname>/zfs.nix
{ config, lib, ... }:
{
  boot.supportedFilesystems         = [ "zfs" ];
  boot.initrd.supportedFilesystems  = [ "zfs" ];

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable      = true;
}