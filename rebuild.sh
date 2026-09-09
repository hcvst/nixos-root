#!/usr/bin/env bash
#
# Build a host's configuration and activate it on a machine that already runs
# NixOS. Complements deploy.sh, which does the *first* install onto a blank
# machine with nixos-anywhere.
#
# By default the build happens here and only the closure is copied over, which
# matters for low-powered targets — ultkv is a 4 GB Atom that would take hours.
# Use --build-host to build elsewhere instead.

set -euo pipefail

readonly PROG=${0##*/}
readonly FLAKE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

hosts() {
  nix eval --raw "${FLAKE_DIR}#nixosConfigurations" \
    --apply 'cs: builtins.concatStringsSep " " (builtins.attrNames cs)' 2>/dev/null
}

usage() {
  cat <<USAGE
usage: $PROG [options] <hostname> <user@target> [action]
       $PROG --list
       $PROG --help

Builds .#<hostname> and activates it on <user@target> over SSH.

  hostname     attribute under nixosConfigurations
  user@target  SSH destination with sudo rights, e.g. kvst@192.168.1.113
  action       nixos-rebuild action; default: boot
                 boot         activate on next reboot (safest for a remote box)
                 switch       activate now and on next boot
                 test         activate now, do not add a boot entry
                 dry-activate show what would change, change nothing

Options:
  -b, --build-host <dest>  build on <dest> (SSH destination) instead of here
  -t, --build-on-target    build on <user@target> itself
  -l, --list               list known hosts
  -h, --help               this text

Where to build:
  default        here, then copy the closure to the target. Best when the
                 target is slow, or the link to it is fast.
  --build-on-target
                 on the target. Best when the target is beefier than this
                 machine, or the link is slow — nothing large is copied.
                 Needs the target to have the build deps and disk space.
  --build-host X on a third machine, e.g. a fast builder. The flake is copied
                 to X, built there, and the closure copied on to the target.

Known hosts: $(hosts)

Examples:
  $PROG ultkv kvst@192.168.1.113                    # build here, activate on boot
  $PROG ultkv kvst@192.168.1.113 switch
  $PROG sheba hcvst@sheba.typed.info -t switch      # build on sheba itself
  $PROG ultkv kvst@192.168.1.113 -b hcvst@sheba     # build on sheba, activate on ultkv
USAGE
}

BUILD_HOST=""
BUILD_ON_TARGET=0
POSITIONAL=()

while [ $# -gt 0 ]; do
  case $1 in
    -h | --help) usage; exit 0 ;;
    -l | --list) hosts; echo; exit 0 ;;
    -t | --build-on-target) BUILD_ON_TARGET=1; shift ;;
    -b | --build-host)
      [ $# -ge 2 ] || { echo "$PROG: --build-host needs a value" >&2; exit 2; }
      BUILD_HOST=$2; shift 2 ;;
    --build-host=*) BUILD_HOST=${1#*=}; shift ;;
    -*) echo "$PROG: unknown option '$1'" >&2; usage >&2; exit 2 ;;
    *) POSITIONAL+=("$1"); shift ;;
  esac
done
set -- "${POSITIONAL[@]+"${POSITIONAL[@]}"}"

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  usage >&2
  exit 2
fi

HOST=$1
TARGET=$2
ACTION=${3-boot}

case $ACTION in
  boot | switch | test | dry-activate) ;;
  *)
    echo "$PROG: unknown action '$ACTION'" >&2
    echo "$PROG: expected one of: boot switch test dry-activate" >&2
    exit 2
    ;;
esac

known=$(hosts)
if [[ " $known " != *" $HOST "* ]]; then
  echo "$PROG: '$HOST' is not a host in this flake" >&2
  echo "$PROG: known hosts: $known" >&2
  exit 2
fi

if [[ $TARGET != *@* ]]; then
  echo "$PROG: target must be <user>@<host>, got '$TARGET'" >&2
  exit 2
fi

if [ "$BUILD_ON_TARGET" = 1 ]; then
  [ -z "$BUILD_HOST" ] || { echo "$PROG: --build-on-target and --build-host are mutually exclusive" >&2; exit 2; }
  BUILD_HOST=$TARGET
fi

args=(
  "$ACTION"
  --flake "${FLAKE_DIR}#${HOST}"
  --target-host "$TARGET"
  --sudo
  --ask-sudo-password
)

# Omitting --build-host makes nixos-rebuild build locally.
if [ -n "$BUILD_HOST" ]; then
  args+=(--build-host "$BUILD_HOST")
  where="on $BUILD_HOST"
else
  where="locally"
fi

echo "Building .#$HOST $where, activating on $TARGET ($ACTION)."
echo
echo "Running:"
printf '  nixos-rebuild'
for a in "${args[@]}"; do
  case $a in
    --*) printf ' \\\n    %s' "$a" ;;
    *) printf ' %q' "$a" ;;
  esac
done
printf '\n\n'

exec nixos-rebuild "${args[@]}"
