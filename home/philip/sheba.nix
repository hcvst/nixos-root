{ config, ... }:
{
  imports = [
    ./global
    ./features/impermanence.nix
  ];
}
