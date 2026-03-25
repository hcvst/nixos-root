{ pkgs, ... }:
{
  users.users.kvst = {
    isNormalUser = true;
    description = "Katarina v. Stockhausen";
    extraGroups = [
      "networkmanager"
    ];
  };
}
