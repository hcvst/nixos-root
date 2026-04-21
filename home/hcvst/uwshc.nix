{ ... }:
{
  imports = [
    ./global
    ../common/optional/sops.nix
  ];
  sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
}
