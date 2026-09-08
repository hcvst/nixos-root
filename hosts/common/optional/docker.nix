{ ... }:
{
  virtualisation.docker.enable = true;

  users.users.hcvst.extraGroups = [ "docker" ];
}
