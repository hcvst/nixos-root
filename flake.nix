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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/${hostname} ];
          specialArgs = {
            inherit inputs hostname;
          };
        };
    in
    {
      # nixos-anywhere --flake .#ulthc --generate-hardware-config nixos-generate-config ./hosts/ulthc/hardware-configuration.nix <hostname>
      nixosConfigurations = {
        uhvhc = mkHost "uhvhc";
        ulthc = mkHost "ulthc";
        uwshc = mkHost "uwshc";
        uwshh = mkHost "uwshh";
        ultkv = mkHost "ultkv";
        ummhc = mkHost "ummhc";
        sbbhc = mkHost "sbbhc";
      };

      # `nix run home-manager/master -- switch --flake .#hcvst`
      # or `nix run .#homeConfigurations.hcvst.activationPackage`
      homeConfigurations = {
        hcvst = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/hcvst/generic.nix
            inputs.sops-nix.homeManagerModules.sops
	    inputs.nix-index-database.homeModules.default
          ];
        };
      };

      # `nix run .#fetchkeys -- <user>@<host>`
      apps.${system} = builtins.mapAttrs (name: pkg: {
        type = "app";
        program = "${pkg}/bin/${name}";
      }) (import ./apps { inherit pkgs; });
    };
}
