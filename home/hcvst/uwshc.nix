{ lib, config, ... }:
{
  imports = [
    ./global
    ../common/optional/sops.nix
    ../common/optional/pet.nix
  ];

  programs.starship.settings.palette = lib.mkForce "oceanic";
  sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

}
