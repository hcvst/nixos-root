{ config, ... }:
{

  imports = [
    ../../common/optional/starship.nix
  ];

  home.username = "philip";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "25.11";

  programs.zsh.enable = true;
}
