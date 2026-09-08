# Pairs with home/<user>/features/desktop/i3 — import both.
# This half enables X, the display manager and the i3 session; the home half writes the user config.
{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager.lightdm.enable = true;
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-utils
    dconf
  ];
}
