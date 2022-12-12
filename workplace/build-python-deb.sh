#!/bin/bash

# ----- work space config -----
WORKDIR="$(pwd)"
SRCDIR="${WORKDIR}/src"
BUILDDIR="${WORKDIR}/build"
LOGDIR="${WORKDIR}/log"

# ----- package config -----
NAME="python"
VERSION="3.10.4"
REVISION="1"
ARCH="amd64"
ME="Chatchai J. <cj@cjv6.net>"
# <name>_<version>-<revision>_<architecture>.deb
PACKAGE="${NAME}_${VERSION}-${REVISION}_${ARCH}"

# ----- sources files -----

OPENSSL_SRC_DL="https://www.openssl.org/source/openssl-1.1.1o.tar.gz"
PYTHON_SRC_DL="https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz"

OPENSSLSRC=$(basename $OPENSSL_SRC_DL)
PYTHONSRC=$(basename $PYTHON_SRC_DL)

sudo apt-get install -y build-essential         \
                        checkinstall            \
                        libreadline-dev         \
                        libncursesw5-dev        \
                        libsqlite3-dev          \
                        tk-dev                  \
                        libgdbm-dev             \
                        libc6-dev               \
                        libbz2-dev              \
                        dpkg-dev

mkdir -p ${SRCDIR} ${BUILDDIR} ${LOGDIR}
cd ${SRCDIR}

[ ! -f "$OPENSSLSRC" ] && wget ${OPENSSL_SRC_DL}
[ ! -f "$PYTHONSRC" ] && wget ${PYTHON_SRC_DL}

cd ${BUILDDIR}

tar -xzf ${SRCDIR}/${OPENSSLSRC}
tar -xzf ${SRCDIR}/${PYTHONSRC}

_OPENSSL="$(ls | grep -i openssl)"
_PYTHON="$(ls  | grep -i python)"

_PYTHON_="$(echo ${_PYTHON} | tr 'A-Z' 'a-z')"

# Build OpenSSL lib
cd ${BUILDDIR}/${_OPENSSL} || { echo "cd failed"; exit; }
(
./config shared --prefix=/opt/${_OPENSSL}/
make
sudo make install
mkdir lib
cp ./*.{so,so.1.1,a,pc} ./lib
) | tee ${LOGDIR}/build-${_OPENSSL}-log

INSTALLED="/opt/${_PYTHON_}"
# Build Python 3.10.4
(
cd ${BUILDDIR}/${_PYTHON} || { echo "cd failed"; exit; }
./configure --prefix=${INSTALLED}/ --with-openssl=${BUILDIR}/${_OPENSSL} --enable-optimizations
make
sudo make install
) | tee ${LOGDIR}/build-${_PYTHON_}-log

cd ${WORKDIR}

[ -d "${PACKAGE}" ] && mv -f "${PACKAGE}" "${PACKAGE}-$(date +%s -r ${PACKAGE})"
mkdir -p ${PACKAGE}${INSTALLED}

cp -av ${INSTALLED}/. ${PACKAGE}${INSTALLED}

mkdir ${PACKAGE}/DEBIAN
touch ${PACKAGE}/DEBIAN/control

cat <<EOT > ${PACKAGE}/DEBIAN/control
Package: ${NAME}
Version: ${VERSION}-${REVISION}
Architecture: ${ARCH}
Maintainer: ${ME}
Description: Interactive high-level object-oriented language (version 3.10)
 Python is a high-level, interactive, object-oriented language. Its 3.10 version
 includes an extensive class library with lots of goodies for
 network programming, system administration, sounds and graphics.

EOT

dpkg-deb --build --root-owner-group ${PACKAGE}
