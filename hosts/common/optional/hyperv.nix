{ lib, ... }:
{

  virtualisation.hypervGuest.enable = true;
  
  services.xrdp = {
    enable = true;
    defaultWindowManager = "i3";
    openFirewall = true;
    # add vsock listener for Hyper-V enhanced session
    extraConfDirCommands = ''
      substituteInPlace $out/xrdp.ini \
        --replace-fail "port=3389" "port=vsock://-1:3389"
    '';
  };

  security.pam.services.xrdp-sesman = {
    allowNullPassword = lib.mkForce false;
  };

  services.xserver.displayManager.sessionCommands = ''
    xrandr --auto
  '';
}
