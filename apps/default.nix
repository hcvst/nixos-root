{ pkgs, ... }:

{
  fetchkeys = import ./fetchkeys.nix { inherit pkgs; };
}