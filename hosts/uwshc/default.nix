# Also see https://github.com/nix-community/NixOS-WSL

{
  inputs,
  hostname,
  pkgs,
  ...
}:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../common/global
    ../common/optional/comin.nix
    ../common/optional/docker-rootless.nix
    ../common/users/hcvst.nix
    ../common/users/hhvst.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "hcvst";
  wsl.interop.includePath = false;
  wsl.wslConf.interop.appendWindowsPath = false;

  networking = {
    hostName = hostname;
    useDHCP = true;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "hcvst" ]; # required for devenv cache
  };


  environment.localBinInPath = true;

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  programs.nix-ld.enable = true;

  services.cron.enable = true;

  system.stateVersion = "25.11";
}
