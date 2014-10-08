#!/bin/bash

set -e

function echo_help {
cat <<USAGE_END
Usage:
  utils/setup-mariadb.sh prod|stg|dev

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

# DB hostname
if [ "$2" ]; then
	DBHOST="$2"
else
	DBHOST='localhost'
fi
if [ "$DBHOST" == 'localhost' ]; then
	DBHOST_ACCESS='localhost'
else
	DBHOST_ACCESS='%'
fi

# Root passwd file path
if [ "$3" ]; then
	ROOT_PASSWD_FPATH="$3"
else
	ROOT_PASSWD_FPATH='conf/db.root-pass.conf'
fi
if [ ! -e "$ROOT_PASSWD_FPATH" ]; then
	echo "Root password file '$ROOT_PASSWD_FPATH' not found!"
	exit 1
fi
ROOT_DB_PASSWD=$(cat $ROOT_PASSWD_FPATH)


TT_DB_NAME="tt${TT_ENV}"
TT_DB_USER="tt${TT_ENV}"
TT_DB_PASSWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)

ROOT_DB_PASSWD=$(cat $ROOT_PASSWD_FPATH)

USER_EXISTS=$(/usr/bin/mysql -h"$DBHOST" -uroot -p"$ROOT_DB_PASSWD" -N -s -r -e $"SELECT 1 FROM mysql.user WHERE user='${TT_DB_USER}'")
if [ "$USER_EXISTS" ]; then
	echo "User '$TT_DB_USER' already exists."
	/usr/bin/mysql -h"$DBHOST" -uroot -p"$ROOT_DB_PASSWD" -e "UPDATE mysql.user SET Password=PASSWORD('$TT_DB_PASSWD') WHERE User='$TT_DB_USER';"
else
	/usr/bin/mysql -h"$DBHOST" -uroot -p"$ROOT_DB_PASSWD" -e "CREATE USER '${TT_DB_USER}'@'${DBHOST_ACCESS}' IDENTIFIED BY '${TT_DB_PASSWD}'";
fi
/usr/bin/mysql -h"$DBHOST" -uroot -p"$ROOT_DB_PASSWD" -e "CREATE DATABASE IF NOT EXISTS ${TT_DB_NAME};"
/usr/bin/mysql -h"$DBHOST" -uroot -p"$ROOT_DB_PASSWD" -e "GRANT ALL ON ${TT_DB_NAME}.* to '${TT_DB_USER}'@'${DBHOST_ACCESS}'"
/usr/bin/mysql -h"$DBHOST" -uroot -p"$ROOT_DB_PASSWD" -e "FLUSH PRIVILEGES;"

CONF_FPATH='conf/web_db.yml'
echo $"---
db:
    name : 'TapTinder (${TT_DB_NAME})'
    dbi_dsn: 'dbi:mysql:database=${TT_DB_NAME};host=${DBHOST}'
    user: '${TT_DB_USER}'
    pass: '${TT_DB_PASSWD}'
" > $CONF_FPATH
chmod og-rwx $CONF_FPATH
echo "Configuration file '$CONF_FPATH' was recreated."

echo "TapTinder '${TT_ENV}' setup finished ok."
