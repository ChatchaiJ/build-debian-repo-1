#!/bin/sh

BASEDIR="/srv/repos/apt/debian"
CODENAME="bullseye"
CODENAME2="bookworm"

reprepro -b $BASEDIR list ${CODENAME}
reprepro -b $BASEDIR list ${CODENAME2}
