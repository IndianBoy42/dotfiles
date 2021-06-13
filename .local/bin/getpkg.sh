#!/usr/bin/env bash

function error_exit
{
  echo "$1" 1>&2
  echo "Usage: ./getpkg.sh <package-name> <packages-directory>" 1>&2
  exit 1
}

PKG="$1"
PKGDIR="$2"

if [ -z "$PKG" ]; then
  error_exit "No package name set!"
fi

if [ -z "$PKGDIR" ]; then
  error_exit "No packages directory path set!"
fi

cd $PKGDIR

for i in $(apt-rdepends $PKG|grep -v "^ ")
  do ! apt-get download $i
done
