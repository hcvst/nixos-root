{
  config,
  inputs,
  lib,
  hostname,
  pkgs,
  ...
}:
{
  imports = [
    ../common/global
    # ../common/optional/comin.nix
    ../common/users/hcvst.nix
    ../common/optional/tailscale.nix
    # ../common/optional/desktop/niri.nix
    # ../common/optional/desktop/sway.nix
    ./disko-config.nix
    ./hardware-configuration.nix
    ./zfs.nix
    ./impermanence.nix
    ./sops.nix
  ];

  # systemd-boot does not support mirroredBoots
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    # efiInstallAsRemovable = true; # hetzner
    device = "nodev";
    mirroredBoots = [
      {
        path = "/boot";
        devices = [ "nodev" ];
        efiSysMountPoint = "/boot";
      }
      {
        path = "/boot-fallback";
        devices = [ "nodev" ];
        efiSysMountPoint = "/boot-fallback";
      }
    ];
  };
  fileSystems."/boot".options = [ "nofail" ];
  fileSystems."/boot-fallback".options = [ "nofail" ];

  boot.initrd.availableKernelModules = [
    "e1000e"
    "igb"
  ];
  boot.kernelParams = [
    "ip=135.181.139.103::135.181.139.65:255.255.255.192::enp0s4:off"
  ];
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      hostKeys = [ "/persist/etc/secrets/initrd/ssh_host_ed25519_key" ];
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPAoIcEYv9mjFujy7fWjMLFt27oGBCNufUHRjiY6hAzZ" # reuse your existing key
      ];
    };
  };
  boot.initrd.systemd.services.zfs-setup-root-profile = {
    wantedBy = [ "initrd.target" ];
    script = ''
      mkdir -p /var/empty
      echo 'systemd-tty-ask-password-agent --watch' >> /var/empty/.profile
    '';
  };

  networking = {
    hostId = "BE629D5D";
    hostName = hostname;
    useDHCP = lib.mkDefault true;
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
    age
    ssh-to-age
    sops
  ];

  # ssh-keygen -y -f ~/.ssh/id_ed25519
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPAoIcEYv9mjFujy7fWjMLFt27oGBCNufUHRjiY6hAzZ"
  ];

  system.stateVersion = "25.11";
}
