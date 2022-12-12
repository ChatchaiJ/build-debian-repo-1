#!/bin/sh

DISTFILE="build-debian-repo.tar.gz"

cd $HOME

rm -f $DISTFILE
echo "REVISION: $(date +%Y/%m/%d-%H:%M)" > workplace/REVISION
tar -czf $DISTFILE		\
	bin/gengpgkey		\
	workplace/REVISION	\
	workplace/*.sh

[ -f "${DISTFILE}" ] && echo "$DISTFILE is created."
