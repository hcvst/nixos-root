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
WARNING: The above does not copy the keys such as `ulthc_host_ed25519
to `/persist/etc/ssh` on the deploy target. FIXME document properly.

See `deploy-ulthc.sh` for deployment prep and actual deployment.

## Remote switch
```
sudo nixos-rebuild switch \
  --flake .#uhvhc \
  --target-host nixos@192.168.1.121 \
  --sudo \
  --ask-sudo-password \
  --build-host localhost
```

## Via install USB
```
nix run github:nix-community/disko -- \
  --flake github:hcvst/nixos-root#HOST \
  --mode disko
```
Will prompt for disk ecryption password

`nixos-install --flake github:hcvst/nixos-root#HOST`

## Create wsl image
Build with 
`sudo nix run .#nixosConfigurations.HOST.config.system.build.tarballBuilder`

Install on Windows with
`wsl --install --from-file nixos.wsl`

## Homemanager Generic
To only run the homemanager config on non-nixos such as Ubuntu, for example:

Expand disk
install nerdfonts

Initially
`nix run home-manager/master -- switch --flake .#hcvst`
- or - 
`nix run .#homeConfigurations.hcvst.activationPackage`

Subsequently 
`home-manager switch --flake .#hcvst`
