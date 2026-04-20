Also see https://github.com/Mic92/sops-nix

# Create keys.txt
```
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
```

# Create .sops.yaml 

## Generate new hosts ssh host key
`ssh-keygen -t ed25519 -N "" -C "hcvst@<hostname>" -f ~/.ssh/<hostname>_host_ed25519`

## Derive age public keys for user and host
```
cat ~/.ssh/id_ed25519.pub | ssh-to-age
cat ~/.ssh/<hostname>_host_ed25519.pub | ssh-to-age
```

```
keys:
  - &hcvst_user age1re53jflrhfmdd0s3zzae6jd8wzvpxz3p7u4rgcajngdmg8qf95kqlvg4cr
  - &hcvst_host age1cqxpx2mgs4ae5dpgrf62qzf6sxephv2dtaw24el5py7yj9va44qsqky4fd

creation_rules:
  - path_regex: secrets/hcvst\.yaml$
    key_groups:
      - age:
          - *hcvst_user
          - *hcvst_host
```

# Create secrets/hcvst.yaml

`mkdir secrets`
`sops hcvst.yaml`

and reference the above from sops.nix via sops.defaultSopsFile
