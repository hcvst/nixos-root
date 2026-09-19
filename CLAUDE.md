# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal NixOS flake managing several machines (bare metal, Hetzner server, Hyper-V VM, WSL) plus a
standalone Home Manager config for non-NixOS Linux. Nixpkgs and Home Manager track `25.11`.

## Commands

Check that all flake outputs evaluate:

```bash
nix flake check
```

Note this currently **fails on `ummhc`**, which pulls in the insecure `broadcom-sta` driver
and uses several renamed `services.xserver.*` options. Every other host evaluates; use the
single-host form below while that is outstanding.

Evaluate a single host (much faster than a full `flake check` when iterating on one machine):

```bash
nix eval .#nixosConfigurations.sheba.config.system.build.toplevel.drvPath
```

Format Nix files (the flake pins `nixfmt-rfc-style`; `nixfmt` is in the system packages):

```bash
nixfmt hosts/sheba/default.nix
```

Rebuild locally (`programs.nh` is enabled on most hosts with `flake = "/etc/nixos"`; the `nhos` shell
alias is `nh os switch`):

```bash
sudo nixos-rebuild switch --flake .#<host>
```

Remote build-and-switch onto a machine that already runs NixOS — builds locally, copies the
closure over ([rebuild.sh](rebuild.sh); `--list` shows known hosts, default action is `boot`):

```bash
./rebuild.sh ultkv kvst@192.168.1.113 switch
```

Standalone Home Manager (non-NixOS hosts): `home-manager switch --flake .#hcvst`, first-time
`nix run home-manager/master -- switch --flake .#hcvst`.

WSL image: `sudo nix run .#nixosConfigurations.<host>.config.system.build.tarballBuilder` produces
`nixos.wsl` (gitignored), installed with `wsl --install --from-file nixos.wsl`.

`nix run .#fetchkeys -- <user>@<host>` is a flake app defined in [apps/](apps/default.nix).

See [README.md](README.md) for `nixos-anywhere` / disko install invocations, and
[deploy.sh](deploy.sh) for the full first-deploy flow (host key + initrd key generation,
ZFS passphrase, `--extra-files`).

## Structure and conventions

`hosts/<hostname>/` is the NixOS side, `home/<username>/<hostname>.nix` the Home Manager side. Every
host is registered in [flake.nix](flake.nix) via `mkHost`, which passes `inputs` and `hostname` as
`specialArgs` — host modules take `hostname` as an argument rather than hardcoding
`networking.hostName`.

Modules are split three ways, following the Misterio77/nix-config layout:

- `common/global/` — imported by every host/user unconditionally.
- `common/optional/` — opt-in features a host imports explicitly (`tailscale.nix`, `docker.nix`,
  `docker-rootless.nix`, `comin.nix`, `hyperv.nix`, `desktop/{i3,niri,sway}.nix`).
- `hosts/<hostname>/` — machine-specific: `default.nix`, `hardware-configuration.nix` (generated,
  don't hand-edit), and where applicable `disko-config.nix`, `zfs.nix`, `impermanence.nix`, `sops.nix`.

**The host↔home wiring is by filename.** `hosts/common/users/hcvst.nix` does
`users.hcvst = import ../../../home/hcvst/${config.networking.hostName}.nix`. Adding a host that
imports a user module therefore *requires* creating `home/<user>/<newhostname>.nix`, or evaluation
fails with a missing-path error. The same holds for `hhvst`. `kvst` and `lena` are plain system users
with no Home Manager config.

Desktop environments are two halves the same way:
`hosts/common/optional/desktop/<wm>.nix` enables the compositor, greeter and session,
`home/<user>/features/desktop/<wm>/` writes the user config. Import both or you get a
config nothing starts, or a session with no config. Each file names its counterpart in a
header comment.

Adding a host means: create `hosts/<name>/`, add `home/<user>/<name>.nix` for each user module it
imports, and add the `mkHost` entry in `flake.nix`. Note `hosts/slthc/` exists but is deliberately
not wired into `nixosConfigurations`.

Some settings (nix experimental-features, `programs.nh`, fonts, `nix-ld`, the root authorized key,
duplicated `environment.systemPackages`) are copy-pasted across host `default.nix` files rather than
factored into `common/global`. When editing one of these, check whether the change should apply to
the other hosts too.

## Impermanence / ZFS hosts

`ulthc`, `sheba`, `uhvhc` use ZFS native encryption (`sbbhc` is unencrypted so it can reboot
unattended), all with an erase-your-darlings setup: an initrd
systemd service rolls `rpool/local/root` and `rpool/local/home` back to their `@blank` snapshots on
every boot, and only paths declared in `environment.persistence."/persist"` (system) and
`home.persistence."/persist"` (user, via `home/hcvst/features/impermanence.nix`) survive.

Anything stateful a new service needs must be added to one of those lists, or it is silently lost on
reboot. `/persist` and `/home` are marked `neededForBoot`.

impermanence only *preserves* a file already present in `/persist`; it never creates one.
A declared path with no source yields a dangling symlink, not an empty file — which is how
a stale `sops.age.sshKeyPaths` went unnoticed. Conversely, removing a path from the list
does not delete it: `/persist` is not rolled back, so the data stays, it just stops being
bind-mounted.

`sheba` (Hetzner) additionally has a two-disk mirrored-boot GRUB setup, static `boot.kernelParams`
networking, and initrd SSH on port 2222 for remote ZFS unlock.

## Secrets (sops-nix)

All secrets live in the single encrypted [secrets/secrets.yaml](secrets/secrets.yaml),
age-encrypted to the recipients in [.sops.yaml](.sops.yaml) — all derived from SSH ed25519
keys via `ssh-to-age`, so there is no separate keypair to manage.

**Three things decrypt that file, each with a different key.** A secret can work in one
context and silently fail in another, so identify the context before debugging:

- **sops CLI** (you, editing) — `~/.config/sops/age/keys.txt`.
- **NixOS system** (root, at activation) — the machine's host key, via
  `sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ]` in
  `hosts/<host>/sops.nix`. Lands in `/run/secrets`, or `/run/secrets-for-users` for
  `neededForUsers` secrets like `hcvst/hashedPassword`. No systemd unit — it is an
  activation script, so `systemctl status sops-nix` finding nothing is expected.
- **Home Manager** (you, at login) — your `~/.ssh/id_ed25519`, only on hosts whose
  `home/hcvst/<host>.nix` imports `../common/optional/sops.nix` (uwshc, sheba, ultkv,
  generic). Runs a user unit `sops-nix.service`; lands in `$XDG_RUNTIME_DIR/secrets.d`.

`.sops.yaml` is read by the sops CLI **only** — NixOS never reads it. It governs writes, so
adding a recipient does nothing to an existing file until `sops updatekeys`. Anchors follow
`<user>_<host>` for user keys and `host_<host>` for host keys; two anchors may share one age
value (sops deduplicates recipients), which records which machines hold that key.

`sops.age.generateKey = false` throughout — keys are never generated on a host. The host key
is generated on the workstation as `~/.ssh/<host>_host_ed25519` and installed by
[deploy.sh](deploy.sh) under the standard name `/persist/etc/ssh/ssh_host_ed25519_key`; the
config must reference the latter. `deploy.sh` places only the host and initrd keys, never
your personal one. See [secrets/README.md](secrets/README.md) for the onboarding sequence.

## GitOps

`hosts/common/optional/comin.nix` runs [comin](https://github.com/nlewo/comin) against
`github.com/hcvst/nixos-root` branch `main`, so a host importing it auto-deploys on push (polled
every 60s, `switch`). Enabled on `uwshc`, `uwshh` and `sbbhc`; commented out on `ulthc`, `sheba`
and `uhvhc`. **Pushing to `main` deploys machines** — and `sbbhc` is unattended and physically
out of reach, so a broken `main` can strand it. Comin also watches a per-host `testing-<host>`
branch with operation `test`, which a reboot undoes; use it for risky `sbbhc` changes.
