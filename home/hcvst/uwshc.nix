{pkgs, ...}: { 


home.username = "hcvst";
home.homeDirectory = "/home/hcvst";
home.stateVersion = "25.11";
home.sessionVariables = {
    EDITOR = "vim";
    HELLO = "Zabcic";  ###################### <<< not working???
};

home.packages = [
  pkgs.cowsay
  pkgs.toilet
];

}