{ pkgs, ... }:
{
  programs.niri.enable = true;

  boot.plymouth.enable = true; # hide logs behing splash so it doesn't mess up greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri";
        user = "greeter";
      };
    };
  };

  users.users.greeter = { };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = { };
}
