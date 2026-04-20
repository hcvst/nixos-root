{ inputs, config, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/hcvst.yaml;
    defaultSopsFormat = "yaml";

    # Derive age key from the persisted SSH host key
    age.sshKeyPaths = [ "/persist/etc/ssh/ulthc_host_ed25519" ];
    # age.keyFile = "/persist/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = {
      "hashedPassword".neededForUsers = true; # decrypted early enough for user activation
      # "hcvst/gh-token" = {
      #   owner = "hcvst";
      #   path  = "/persist/home/hcvst/.config/gh/hosts.yml";
      # };
    };
  };

  users.users.hcvst.hashedPasswordFile = config.sops.secrets."hashedPassword".path;
}
