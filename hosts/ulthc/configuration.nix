{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
{
  imports = [ ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPAoIcEYv9mjFujy7fWjMLFt27oGBCNufUHRjiY6hAzZ"
  ]; 

  system.stateVersion = "25.11";
}
