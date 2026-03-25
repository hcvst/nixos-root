{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      disko,
      home-manager,
      ...
    }@inputs:
    {
      # nixos-anywhere --flake .#ulthc --generate-hardware-config nixos-generate-config ./hosts/ulthc/hardware-configuration.nix <hostname>

      nixosConfigurations = {
        ulthc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/ulthc ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
      uwshc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [./hosts/uwshc];
        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
