{ config, pkgs, ... }:
{

  imports = [
    ../../common/optional/starship.nix
  ];

  home.username = "hhvst";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "25.11";

  programs.zsh = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
    };
  };

  programs.vim.enable = true;
  programs.autojump.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    bat
    devenv
    gh
    git
    lazygit
    terminaltexteffects
    tree
  ];

}
