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

  users.users.lena = {
    isNormalUser = true;
    description = "Lena von Stockhausen";
    shell = pkgs.zsh; # do we need this, if we have it in home-manager? #FIXME
    extraGroups = [ "networkmanager" ];
    packages = with pkgs; [
      blockbench
      firefox
      prismlauncher
      stone-kingdoms
      lenmus
      widelands
      libreoffice-qt
    ];
  };

  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  # home-manager.users.hhvst = import ../../../home/hhvst/${config.networking.hostName}.nix;

  home-manager.users.lena =
    { pkgs, ... }:
    {
      home.packages = [ ];
      programs.zsh.enable = true;

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "23.11";
    };

}
