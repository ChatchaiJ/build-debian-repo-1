#!/bin/sh

BASEDIR="/srv/repos/apt/debian"
CONFDIR="${BASEDIR}/conf"
DISTFILE="${CONFDIR}/distributions"
OPTIONS="${CONFDIR}/options"

DEBWORKDIR="/home/cj/workplace"
# DEBFILE="${DEBWORKDIR}/python_3.10.4-1_amd64.deb"
DEBFILE="python_3.10.4-1_amd64.deb"

PROJECT="CJ Debian Repository Test"
OSRELEASE="bullseye"
OSRELEASE_TESTING="bookworm"

KEYID="$(cat /home/cj/.gpg-fingerprint)"

sudo mkdir -p ${CONFDIR}
sudo chown -R cj ${BASEDIR}

cat << EOT > ${DISTFILE}
Origin: ${PROJECT}
Label: ${PROJECT}
Codename: ${OSRELEASE}
Architectures: amd64
Components: main
Description: Apt repository for project ${PROJECT}
SignWith: ${KEYID}

Origin: ${PROJECT}
Label: ${PROJECT}
Codename: ${OSRELEASE_TESTING}
Architectures: amd64
Components: main
Description: Apt repository for project ${PROJECT}
SignWith: ${KEYID}
EOT

cat << EOT > ${OPTIONS}
verbose
basedir ${BASEDIR}
ask-passphrase
EOT

# cd $BASEDIR || { echo "Cant't change directory to $BASEDIR"; exit; }
# reprepro includedeb ${OSRELEASE} ${DEBFILE}
# reprepro includedeb ${OSRELEASE_TESTING} ${DEBFILE}

sudo apt-get install -y reprepro
reprepro -V -b ${BASEDIR} -S python -C main -P standard includedeb ${OSRELEASE} ${DEBFILE}
