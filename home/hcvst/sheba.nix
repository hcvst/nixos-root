{ config, ... }:
{
  imports = [
    ./global
    ./features/impermanence.nix
    ../common/optional/sops.nix
    ../common/optional/pet.nix
  ];

  sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
}
