#!/bin/bash

set -e
set -x

TTCONF_DIR='/opt/taptinder/server/conf'
TTDATA_DIR='/opt/taptinder/server/data';
TTROOT_DIR='/home/ttus/tt-server/root'

if [ -e "$TTCONF_DIR/db.root-pass.conf" ]; then
	echo "Setup already done."
	#exit
fi

if [ "$1" ]; then
	FAST=1
fi

echo -n "Working dir:"
pwd

mkdir -p -m 0700 $TTCONF_DIR
chown ttus:ttus $TTCONF_DIR
touch $TTCONF_DIR/db.root-pass.conf
chown ttus $TTCONF_DIR/db.root-pass.conf

if [ ! -e "$TTCONF_DIR/db.root-pass.conf" ]; then
	utils/mysql-secure.sh $TTCONF_DIR/db.root-pass.conf regen secure
	cd ../tt-server/
	utils/setup-mariadb.sh docker db $TTCONF_DIR/db.root-pass.conf $TTCONF_DIR/web_db.yml
fi

if [ ! -s "$TTROOT_DIR/dbdoc" ]; then
	mkdir -p $TTDATA_DIR/dbdoc
	ln -s -T $TTDATA_DIR/dbdoc $TTROOT_DIR/dbdoc
fi

mkdir -p $TTDATA_DIR/deploy-ddl

echo "Running utils/all-sql.sh"
if [ "$FAST" ]; then
	utils/all-sql.sh base $TTCONF_DIR $TTDATA_DIR/deploy-ddl $TTDATA_DIR/dbdoc
else
	utils/all-sql.sh images $TTCONF_DIR $TTDATA_DIR/deploy-ddl $TTDATA_DIR/dbdoc
fi
echo ""

echo "Executing utils/deploy.pl --drop --deploy --data=dev ..."
perl utils/deploy.pl --drop --deploy --data=dev --conf_dir $TTCONF_DIR --ddl_dir $TTDATA_DIR/deploy-ddl
echo ""

# References (rref table) not loaded yet.
#echo "Executing utils/db-fill-sqldata.pl sql/data-dev-jobs.pl"
#perl utils/db-fill-sqldata.pl sql/data-dev-jobs.pl $TTCONF_DIR
#echo ""

mkdir -p $TTROOT_DIR/file
mkdir -p /opt/taptinder/server/data/cmdout
mkdir -p /opt/taptinder/server/data/archive
if [ ! -s $TTROOT_DIR/file/cmdout ]; then
	ln -s -T /opt/taptinder/server/data/cmdout $TTROOT_DIR/file/cmdout
fi
if [ ! -s $TTROOT_DIR/file/archive ]; then
	ln -s -T /opt/taptinder/server/data/archive $TTROOT_DIR/file/archive
fi

# Config file 'conf/web_db.yml' createad by setup-mariadb.sh above.
if [ ! -f "$TTCONF_DIR/web_project.yml" ]; then
	cp conf/web_project.yml.example $TTCONF_DIR/web_project.yml
	cp conf/web.yml.example $TTCONF_DIR/web.yml
	chmod -R a-rwx,u+r $TTCONF_DIR/*
	chmod a-rwx,u+rwx $TTCONF_DIR
fi

cp $TTROOT_DIR/lib/config/main.example $TTROOT_DIR/lib/config/main

mkdir -p /tmp/taptinder /tmp/taptinder/uploads
chown -R ttus:ttus /tmp/taptinder /tmp/taptinder/uploads
chmod a-rwx,u+rwx /tmp/taptinder /tmp/taptinder/uploads

TAPTINDER_SERVER_CONF_DIR=$TTCONF_DIR perl -Ilib t/01app.t
