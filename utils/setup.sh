#!/bin/bash

set -e

function echo_help {
cat <<USAGE_END
Usage:
  utils/setup.sh prod|stg|dev

USAGE_END
}

if [ -z "$1" ]; then
    echo_help
    exit
fi

if [ "$1" = "prod" ]; then
	TT_ENV='prod'
elif [ "$1" = "stg" ]; then
	TT_ENV='stg'
elif [ "$1" = "dev" ]; then
	TT_ENV='dev'
else
	echo_help
	exit 1
fi


echo "Preparing TapTinder ($TT_ENV) server setup"
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
