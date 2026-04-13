{pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    bat
    gh
    helix
    nixfmt
    tree
  ];
}

