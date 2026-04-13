# Nixos configurations

## References
- https://github.com/Misterio77/nix-config
- https://haseebmajid.dev/posts/2024-07-30-how-i-setup-btrfs-and-luks-on-nixos-using-disko
- https://nix-community.github.io/nixos-anywhere/quickstart

## Configuration Health check
`nix flake check`

## nixos-anywhere
```
nix run github:nix-community/nixos-anywhere -- --flake .#ulthc \
  --generate-hardware-config nixos-generate-config \
  ./hosts/ulthc/hardware-configuration.nix --target-host <user>@<hostname>
```

See `deploy-ulthc.sh` for deployment prep and actual deployment.

## From install USB
```
nix run github:nix-community/disko -- \
  --flake github:hcvst/nixos-root#HOST \
  --mode disko
```

Will prompt for disk ecryption password

`nixos-install --flake github:hcvst/nixos-root#HOS`