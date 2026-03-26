{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # comin provides GitOps for Nixos
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/${hostname} ];
          specialArgs = {
            inherit inputs hostname;
          };
        };
    in
    {
      # nixos-anywhere --flake .#ulthc --generate-hardware-config nixos-generate-config ./hosts/ulthc/hardware-configuration.nix <hostname>
      nixosConfigurations = {
        ulthc = mkHost "ulthc";
        uwshc = mkHost "uwshc";
        ultkv = mkHost "ultkv";
      };
    };
}
