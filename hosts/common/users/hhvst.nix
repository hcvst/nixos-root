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

  users.users.hhvst = {
    isNormalUser = true;
    description = "Hans Heinrich von Stockhausen";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" ];
    packages = with pkgs; [

    ];
  };

  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.hhvst = import ../../../home/hhvst/${config.networking.hostName}.nix;
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];
  };
}
