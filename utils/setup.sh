#!/bin/bash

set -e

echo "Preparing TapTinder server setup"
mkdir -p temp
mkdir -p temp/dbdoc
if [ ! -s root/dbdoc ]; then
	ln -s -T ../temp/dbdoc root/dbdoc
fi
mkdir -p ../server-repos
mkdir -p ../server-data/
mkdir -p ../server-data/cmdout
mkdir -p ../server-data/archive
mkdir -p root/file
if [ ! -s root/file/cmdout ]; then
	ln -s -T ../../../server-data/cmdout root/file/cmdout
fi
if [ ! -s root/file/archive ]; then
	ln -s -T ../../../server-data/archive root/file/archive
fi
echo "Setup finished ok"
