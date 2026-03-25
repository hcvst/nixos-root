{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../common/users/hcvst.nix
    ./disko-config.nix
    ./hardware-configuration.nix 
    ./sway-requirements.nix
    inputs.disko.nixosModules.disko
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "ulthc";
    useDHCP = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [ "hcvst" ]; # required for devenv cache

  environment.localBinInPath = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  programs.nix-ld.enable = true;

  services.cron.enable = true;
  services.openssh.enable = true;

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

  # ssh-keygen -y -f ~/.ssh/id_ed25519
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPAoIcEYv9mjFujy7fWjMLFt27oGBCNufUHRjiY6hAzZ"
  ];

  system.stateVersion = "25.11";

}
