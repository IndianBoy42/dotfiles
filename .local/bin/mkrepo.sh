#!/usr/bin/env bash

function error_exit
{
  echo "$1" 1>&2
  echo "Usage: ./mkrepo.sh <packages-directory>" 1>&2
  exit 1
}

PKGDIR="$1"

if [ -z "$PKGDIR" ]; then
  error_exit "No packages directory path set!"
fi

cd $PKGDIR

dpkg-scanpackages ./ /dev/null | gzip -9c > ./Packages.gz
