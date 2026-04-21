{ pkgs, ... }:
{
  users.mutableUsers = false;

  time.timeZone = "Africa/Johannesburg";

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    bat
    #   devenv
    #   eza
    #   fastfetch
    #   fzf
    gh
    #   glow
    helix
    #   lld
    #   mdcat
    tree
    #   wget
    #   zk
    # nvim
    nixfmt
  ];
}
