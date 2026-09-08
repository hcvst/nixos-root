# Pairs with home/<user>/features/desktop/sway — import both.
# This half installs sway and enables the greeter; the home half writes the user config.
{ pkgs, ... }:
{
  programs.dconf.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
  
  users.users.greeter = { };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = { };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    grim
    mako
    slurp
    sway
    wl-clipboard
  ];
}
## SEE https://d19qhx4ioawdt7.cloudfront.net/docs/nix-home-manager-sway.html
