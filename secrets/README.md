# Secrets with sops-nix

Upstream docs: https://github.com/Mic92/sops-nix

sops encrypts the *values* in `secrets/secrets.yaml` and leaves the keys
readable, so the file stays diffable in a public repo. Recipients are `age`
keys, each derived from an SSH ed25519 key we already have (`ssh-to-age`), so
there is no extra keypair to back up. Any *one* recipient can decrypt the file.

## The three contexts

Three different things decrypt the same file, each with its own key. A secret
can work in one context and silently fail in another, so this is the bit to
keep straight:

| context | key it uses | configured in | lands in |
| --- | --- | --- | --- |
| sops CLI (you, editing) | `~/.config/sops/age/keys.txt` | â | your `$EDITOR` |
| NixOS system (root, at activation) | the machine's **host** key | `hosts/<host>/sops.nix` | `/run/secrets`, or `/run/secrets-for-users` |
| Home Manager (you, at login) | your **user** key `~/.ssh/id_ed25519` | `home/hcvst/<host>.nix` | `$XDG_RUNTIME_DIR/secrets.d` |

`hcvst/hashedPassword` must be a system secret: it is `neededForUsers`, so it
has to decrypt before your account exists and cannot depend on anything you own.
`hcvst/pet` is a user secret (gist token, see `home/common/optional/pet.nix`).

Home Manager runs a user unit, `sops-nix.service`. The NixOS module does not â
it is an activation script, so `systemctl status sops-nix` finding nothing on a
system-only host is expected. Look at `/run/secrets*` instead.

A host gets Home Manager secrets only if its `home/hcvst/<host>.nix` imports
`../common/optional/sops.nix`. Today that is uwshc, sheba, ultkv and generic;
ulthc, uhvhc, sbbhc and uwshh have system secrets or none.

## Configuration

`.sops.yaml` is read by the **sops CLI only** â NixOS never reads it. It decides
who files get encrypted to when written, so adding a recipient does nothing to
an existing file until you re-encrypt it with `sops updatekeys`. See that file
for the anchor naming convention (`<user>_<host>` and `host_<host>`).

Each host names the key it decrypts with:

```nix
sops = {
  defaultSopsFile = ../../secrets/secrets.yaml;
  age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
  age.generateKey = false;   # keys are never generated on the host
  secrets."hcvst/hashedPassword".neededForUsers = true;
};
```

## Onboarding a host

**The host key**, at deploy time. `deploy.sh` walks you through it: it generates
the host key, prints the derived age pubkey, tells you to add it to `.sops.yaml`
as `host_<host>` and run `sops updatekeys`, then waits before deploying. Both
halves matter — with the anchor added but the secrets not re-encrypted, the host
decrypts nothing: `/run/secrets*` never appears and `neededForUsers` secrets fail
silently.

**The user key**, only if the host gets Home Manager secrets (its
`home/hcvst/<host>.nix` imports `../common/optional/sops.nix`). An anchor names a
*public key*, not a machine, so which case you are in depends on whether the host
reuses a personal key you already have:

- *Reusing an existing key* (uwshc, sheba). Add `&hcvst_<host>` with the same age
  value as its sibling, then copy `~/.ssh/id_ed25519` onto the host yourself —
  `deploy.sh` installs only the host and initrd keys, never your personal one.
  No `updatekeys`: that key is already a recipient, so the duplicate anchor is
  pure documentation of which machines hold it, and can be added at any time.
- *A key of its own* (ultkv, generic). Generate it on the host, then
  `nix run .#fetchkeys -- <user>@<host>`, add the anchor, and re-encrypt with
  `sops updatekeys secrets/secrets.yaml`.

## Editing and rotating

```
sops secrets/secrets.yaml               # or: nix run nixpkgs#sops -- secrets/secrets.yaml
```

Re-encrypts on save to the current recipients. Changing a *value* needs no
`updatekeys` â that is only for changing *who* can decrypt. Never `sops -d` into
a file or a pipe you might echo; edit in place. Rebuild the hosts that consume a
secret afterwards, since values are materialised at activation.

First time on a workstation, give the CLI your key:

```
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
```

## Gotchas

- **The host key is renamed on the way in.** Generated as
  `~/.ssh/<hostname>_host_ed25519`, installed by `deploy.sh` as
  `/persist/etc/ssh/ssh_host_ed25519_key`. `age.sshKeyPaths` must use the
  latter â which is also what `ssh-keyscan`, and so `fetchkeys`, returns.
- **`nixos-anywhere` copies no keys by itself** â only via `--extra-files`,
  which `deploy.sh` assembles.
- **`environment.persistence` does not create a file.** impermanence preserves
  one already in `/persist`; otherwise it leaves a dangling symlink in `/etc/ssh`.
- **Anchor names are local to `.sops.yaml`.** Renaming needs no re-encryption,
  and two anchors may share a key â sops deduplicates recipients.
