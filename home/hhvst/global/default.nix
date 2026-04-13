{ pkgs, config, ... }:
{
  home.username = "hhvst";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    httpie
    blockbench
    firefox
    prismlauncher
    stone-kingdoms
    lenmus
    widelands
    libreoffice-qt
  ];

  programs.zsh.enable = true;
}
