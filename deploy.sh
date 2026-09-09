#!/usr/bin/env bash
set -euo pipefail

HOST=${1:?usage: deploy.sh <hostname> <target-ip>}
TARGET=${2:?usage: deploy.sh <hostname> <target-ip>}

STAGING=$(mktemp -d)
echo "Staging files in $STAGING"
# trap "rm -rf $STAGING" EXIT

SSH_DIR="$STAGING/extra-files/persist/etc/ssh"
mkdir -p "$SSH_DIR"

# Generate host key if it doesn't exist in ~/.ssh yet
KEY=~/.ssh/${HOST}_host_ed25519
if [ ! -f "$KEY" ]; then
  echo "Generating host key for $HOST..."
  ssh-keygen -t ed25519 -N "" -C "root@${HOST}" -f "$KEY"
  echo ""
  echo ">>> Add this age pubkey to .sops.yaml for $HOST:"
  cat "${KEY}.pub" | ssh-to-age
  echo ""
  echo "Then re-encrypt secrets: sops updatekeys secrets/*.yaml"
  echo "Commit .sops.yaml and re-encrypted secrets before continuing."
  read -p "Press enter when done..."
fi

cp "$KEY"     "$SSH_DIR/ssh_host_ed25519_key"
cp "${KEY}.pub" "$SSH_DIR/ssh_host_ed25519_key.pub"
chmod 600 "$SSH_DIR/ssh_host_ed25519_key"


# Create initrd unlock key to use to unlock the disk encryption at boot. 
#This is a separate key from the host key, and is only used for unlocking the disk encryption in the initrd.
INITRD_DIR="$STAGING/extra-files/persist/etc/secrets/initrd"
mkdir -p "$INITRD_DIR"
INITRD_KEY=~/.ssh/${HOST}_initrd_ed25519
if [ ! -f "$INITRD_KEY" ]; then
  echo "Generating initrd unlock key for $HOST..."
  ssh-keygen -t ed25519 -N "" -C "initrd@${HOST}" -f "$INITRD_KEY"
fi
cp "$INITRD_KEY"      "$INITRD_DIR/ssh_host_ed25519_key"
# .pub not really needed as this is only the host key 
cp "${INITRD_KEY}.pub" "$INITRD_DIR/ssh_host_ed25519_key.pub"
chmod 600 "$INITRD_KEY"


echo "Deploying $HOST to $TARGET..."
nixos-anywhere \
  --flake ".#$HOST" \
  --extra-files "$STAGING/extra-files" \
  --disk-encryption-keys /tmp/secret.key <(read -rsp "ZFS passphrase: " p && echo -n "$p") \
  root@"$TARGET"