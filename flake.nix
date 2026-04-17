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
    impermanence.url = "github:nix-community/impermanence";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
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
        uwshh = mkHost "uwshh";
        ultkv = mkHost "ultkv";
        ummhc = mkHost "ummhc";
        #sbbhc = mkHost "sbbhc";
      };

      # `nix run home-manager/master -- switch --flake .#hcvst`
      # or `nix run .#homeConfiguration.hcvst.activationPackage`
      homeConfigurations = {
        hcvst = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home/hcvst/generic.nix ];
        };
      };
    };
}
