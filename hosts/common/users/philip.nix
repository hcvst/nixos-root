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

  users.users.philip = {
    isNormalUser = true;
    description = "Philip Correia";
    shell = pkgs.zsh;
    extraGroups = [ ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGhJOygYNbqV5Abju/yhynTITZFAnoZbwvmZh9/XZpg"
    ];
    packages = with pkgs; [

    ];
  };

  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.philip = import ../../../home/philip/${config.networking.hostName}.nix;
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];
  };
}
