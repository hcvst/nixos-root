# Also see https://github.com/nix-community/NixOS-WSL

{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../common/users/hcvst.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "hcvst";

  networking = {
    hostName = "uwshc";
    useDHCP = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [ "hcvst" ]; # required for devenv cache

  environment.localBinInPath = true;

  fonts.packages = with pkgs; [
    # nerd-fonts.fira-code
    # nerd-fonts.droid-sans-mono
  ];

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  programs.nix-ld.enable = true;

  services.cron.enable = true;

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

  system.stateVersion = "25.11";
}
