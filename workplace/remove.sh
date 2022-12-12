#!/bin/sh

BASEDIR="/srv/repos/apt/debian"
CODENAME="bullseye"
CODENAME2="bookworm"

reprepro -b $BASEDIR remove ${CODENAME} python
reprepro -b $BASEDIR remove ${CODENAME2} python
