#!/bin/sh
set -eu

sudo nix run github:nix-community/disko \
  --extra-experimental-features "nix-command flakes" -- \
  --mode destroy,format,mount \
  --flake .#thinkpad-t490 \
  --yes-wipe-all-disks

sudo nixos-install \
  --no-root-password \
  --flake .#thinkpad-t490

sudo nixos-enter --root /mnt -c "passwd samir"

sudo reboot now
