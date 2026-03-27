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

  home-manager.users.hhvst =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.httpie ];
      programs.zsh.enable = true;

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "23.11";
    };

}
