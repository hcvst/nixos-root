# WORKAROUND — remove once the hoster fixes their network.
#
# Some HTTPS endpoints (e.g. elitehost.co.za, auth.docker.io) fail from this
# box with "connection reset by peer" immediately after the TLS Client Hello.
# Cause: modern TLS stacks offer the post-quantum hybrid group X25519MLKEM768
# by default; its ~1.2 KB key share pushes the Client Hello past one TCP
# segment, and a middlebox on the provider's network resets any handshake that
# spans two segments. This is the failure catalogued at https://tldr.fail/.
#
# It has to be fixed twice, because the two TLS stacks here share nothing:
#
#   OpenSSL  — curl, git, python, the openssl CLI. Driven by an openssl.cnf.
#   Go       — dockerd, gh, and anything else built in Go. crypto/tls does not
#              read OpenSSL config at all; it has its own GODEBUG knob.
#
# Both are set for login shells (environment.variables) and for systemd units
# (systemd.globalEnvironment), since services need them too — the Docker
# symptom was a registry pull failing inside dockerd.
#
# X25519MLKEM768 is deliberately absent entirely rather than merely last: a
# server preferring it would answer HelloRetryRequest, making the second Client
# Hello large again and re-triggering the reset.
#
# Note environment.etc alone would NOT work for OpenSSL. The nixpkgs openssl
# reports OPENSSLDIR as its own store path, not /etc/ssl, so a file dropped at
# /etc/ssl/openssl.cnf is never read; OPENSSL_CONF is the supported override.
# The config layers over the packaged openssl.cnf with `.include` rather than
# replacing it, so the provider section and [req]/[ca] defaults survive.
#
# Config is parsed once per process: after a switch, restart long-running
# services (or reboot) for them to pick this up.

{ pkgs, ... }:
{
  # OpenSSL clients.
  environment.etc."ssl/openssl.cnf".text = ''
    .include ${pkgs.openssl.out}/etc/ssl/openssl.cnf

    [openssl_init]
    ssl_conf = ssl_sect

    [ssl_sect]
    system_default = system_default_sect

    [system_default_sect]
    Groups = X25519:P-256:X448:P-384:P-521
  '';

  # Go clients. tlsmlkem=0 makes crypto/tls fall back to
  # [X25519, P-256, P-384, P-521] — see crypto/tls/defaults.go.
  environment.variables = {
    OPENSSL_CONF = "/etc/ssl/openssl.cnf";
    GODEBUG = "tlsmlkem=0";
  };

  systemd.globalEnvironment = {
    OPENSSL_CONF = "/etc/ssl/openssl.cnf";
    GODEBUG = "tlsmlkem=0";
  };
}
