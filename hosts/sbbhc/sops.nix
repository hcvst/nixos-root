{ inputs, config, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # Derive age key from the persisted SSH host key
    age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    # age.keyFile = "/persist/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = {
      "hcvst/hashedPassword".neededForUsers = true; # decrypted early enough for user activation
      # Tailscale pre-auth key so a fresh install joins the tailnet without a browser login.
      # Create it in the admin console (reusable off, tagged or with key expiry disabled afterwards).
      "sbbhc/tailscale-authkey" = { };
      # "hcvst/gh-token" = {
      #   owner = "hcvst";
      #   path  = "/persist/home/hcvst/.config/gh/hosts.yml";
      # };
    };
  };

  users.users.hcvst.hashedPasswordFile = config.sops.secrets."hcvst/hashedPassword".path;

  services.tailscale = {
    authKeyFile = config.sops.secrets."sbbhc/tailscale-authkey".path;
    authKeyParameters.preauthorized = true;
  };
}
