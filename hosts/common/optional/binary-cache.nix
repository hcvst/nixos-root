# https://nix.dev/tutorials/nixos/binary-cache-setup.html

{ config, ...}:
{
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/secrets/cache-private-key.pem"; # FIXME 
    # nix-store --generate-binary-cache-key sbbhc cache-private-key.pem cache-public-key.pem
    # Copy to location above
    # Test with `curl http://sbbhc/nix-cache-info`
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."sbbhc" = {
      locations."/" = {
        proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ config.services.nginx.defaultHTTPListenPort ];
}