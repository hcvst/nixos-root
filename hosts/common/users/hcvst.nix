{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.hcvst = {
    isNormalUser = true;
    description = "Hans Christian v. Stockhausen";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = lib.mkDefault "$y$j9T$prwAj9dAN8ET411Gdj0tJ0$z6cXxOdGEjqpnOIq1yRxpnAl4msZEUSZqdx92YVhatB";
  };

  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.hcvst = import ../../../home/hcvst/${config.networking.hostName}.nix;
  };
}
