#!/bin/bash

set -e
set -x

# Root passwd file path
if [ "$1" = '-' ]; then
	ROOT_PASSWD_FPATH='/etc/mysql.root-pass.conf'
else
	ROOT_PASSWD_FPATH="$1"
fi
if [ ! -e "$ROOT_PASSWD_FPATH" ]; then
	echo "Root password file '$ROOT_PASSWD_FPATH' must already exists!"
	exit 1
fi

# Root passwd
if [ "$2" = "use" ]; then
	echo "Using already set root password from '$ROOT_PASSWD_FPATH'."
	ROOT_DB_PASSWD=$(cat $ROOT_PASSWD_FPATH)

elif [ "$2" = "regen" ]; then
	NEW_ROOT_DB_PASSWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
	UPDATE_SQL="UPDATE mysql.user SET Password=PASSWORD('$NEW_ROOT_DB_PASSWD') WHERE User='root'; FLUSH PRIVILEGES;"
	if [ -e "$ROOT_PASSWD_FPATH" ]; then
		ROOT_DB_PASSWD=$(cat $ROOT_PASSWD_FPATH)
		if [ "$ROOT_DB_PASSWD" ]; then
			/usr/bin/mysql -hdb -uroot -p"$ROOT_DB_PASSWD" -e "$UPDATE_SQL";
		else
			/usr/bin/mysql -hdb -uroot -e "$UPDATE_SQL";
		fi
	else
		/usr/bin/mysql -hdb -uroot -e "$UPDATE_SQL";
	fi
	echo "$NEW_ROOT_DB_PASSWD" > $ROOT_PASSWD_FPATH
	chmod og-rwx $ROOT_PASSWD_FPATH
	echo "MariaDB root password (re)generated and saved to '$ROOT_PASSWD_FPATH'!"

else
	echo_help
	exit 1
fi

# Secure
ROOT_DB_PASSWD=$(cat $ROOT_PASSWD_FPATH)
if [ "$3" = "secure" ]; then
	# secure setup
	# ToDo - cat /usr/bin/mysql_secure_installation
	/usr/bin/mysql -hdb -uroot -p"$ROOT_DB_PASSWD" -e $"DELETE FROM mysql.user WHERE User=''; DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('%', 'localhost'); FLUSH PRIVILEGES; DROP DATABASE IF EXISTS test;"
	/usr/bin/mysql -hdb -uroot -p"$ROOT_DB_PASSWD" -N  -e 'select * from mysql.user'
	/usr/bin/mysql -hdb -uroot -p"$ROOT_DB_PASSWD" -N -e "SHOW GRANTS FOR 'root'@'%';"
elif [ "$3" = "no" ]; then
	echo "Skipping of /usr/bin/mysql_secure_installation like fix."
else
	echo_help
	exit 1
fi
