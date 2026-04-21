{ config, lib, ... }:
{
  imports = [
    ./global
    ../common/optional/sops.nix
    ../common/optional/pet.nix
  ];

  targets.genericLinux.enable = true;

  programs.starship.settings.palette = lib.mkForce "oceanic";
  sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
}
