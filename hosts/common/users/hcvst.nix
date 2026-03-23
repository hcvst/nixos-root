{pkgs, config, lib, inputs, ...}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.hcvst = {
  isNormalUser = true;
  shell = pkgs.zsh;
  extraGroups = [ "wheel" ];
  openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../home/hcvst/ssh.pub);
  hashedPassword = "$y$j9T$prwAj9dAN8ET411Gdj0tJ0$z6cXxOdGEjqpnOIq1yRxpnAl4msZEUSZqdx92YVhatB";
  };

  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  
  home-manager.users.hcvst = import ../../../home/hcvst/${config.networking.hostName}.nix;
}


