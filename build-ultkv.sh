#!/usr/bin/env bash
# Note to self how to run remote build
nixos-rebuild boot --flake .#ultkv --target-host kvst@192.168.1.113 --sudo --ask-sudo-password
