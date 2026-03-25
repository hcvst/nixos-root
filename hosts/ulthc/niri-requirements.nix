{ pkgs, ... }:
rec {
  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri";
        user = "greeter";
      };
    };
  };

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = { };

  users.users.greeter = { };

}

## SEE https://d19qhx4ioawdt7.cloudfront.net/docs/nix-home-manager-sway.html
