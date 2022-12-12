#!/bin/sh

NAME="cj-test"
TMPGPG="$(mktemp /tmp/XXXXX.gpg)"
TARGET="/etc/apt/trusted.gpg.d/${NAME}.gpg"

SRCLIST="/etc/apt/sources.list.d/${NAME}.list"

gpg --export $(cat .gpg-fingerprint) > $TMPGPG
sudo mv $TMPGPG $TARGET
sudo chown root:root $TARGET
sudo chmod 644 $TARGET

cat <<EOT > /tmp/${NAME}.list
deb http://debian1.cjv6.net/debian bullseye main
EOT

sudo mv /tmp/${NAME}.list /etc/apt/sources.list.d
sudo chown root:root /etc/apt/sources.list.d/${NAME}.list

sudo apt-get update
apt-cache policy python
