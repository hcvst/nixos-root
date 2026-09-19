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

  # No authKeyParameters: they append "?key=value" to the key, which is only valid for
  # OAuth client secrets. A plain tskey-auth key is then rejected as "invalid key".
  # The key is single-use and only matters on a fresh install; afterwards the login
  # lives in the persisted /var/lib/tailscale and the autoconnect unit is a no-op.
  services.tailscale.authKeyFile = config.sops.secrets."sbbhc/tailscale-authkey".path;
}
