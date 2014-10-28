#!/bin/bash

set -e
set -x

if [ "$1" ]; then
	FAST=1
fi

echo -n "Working dir:"
pwd

TTCONF_DIR='/home/taptinder/tt-server/conf'
TTROOT_DIR='/home/taptinder/tt-server/root'

mkdir -p -m 0700 $TTCONF_DIR
chown taptinder:taptinder $TTCONF_DIR
touch $TTCONF_DIR/db.root-pass.conf
chown taptinder $TTCONF_DIR/db.root-pass.conf

utils/mysql-secure.sh $TTCONF_DIR/db.root-pass.conf regen secure
cd ../tt-server/
utils/setup-mariadb.sh docker db $TTCONF_DIR/db.root-pass.conf $TTCONF_DIR/web_db.yml

mkdir -p temp
mkdir -p temp/dbdoc
if [ ! -s $TTROOT_DIR/dbdoc ]; then
	ln -s -T ../temp/dbdoc $TTROOT_DIR/dbdoc
fi

echo "Running utils/all-sql.sh"
if [ "$FAST" ]; then
	utils/all-sql.sh base $TTCONF_DIR
else
	utils/all-sql.sh schema-images $TTCONF_DIR
fi
echo ""

echo "Executing utils/deploy.pl --drop --deploy --data=prod"
perl utils/deploy.pl --drop --deploy --data=prod --conf_dir $TTCONF_DIR
echo ""

echo "Copying temp/schema-raw-create.sql to temp/schema-raw-create-dump.sql"
cp temp/schema-raw-create.sql temp/schema-raw-create-dump.sql
echo ""

echo "Executing utils/db-fill-sqldata.pl sql/data-prod-jobs.pl"
perl utils/db-fill-sqldata.pl sql/data-prod-jobs.pl $TTCONF_DIR
echo ""

mkdir -p $TTROOT_DIR/file
mkdir -p /opt/taptinder/server/cmdout
mkdir -p /opt/taptinder/server/archive
if [ ! -s $TTROOT_DIR/file/cmdout ]; then
	ln -s -T /opt/taptinder/server/cmdout $TTROOT_DIR/file/cmdout
fi
if [ ! -s $TTROOT_DIR/file/archive ]; then
	ln -s -T /opt/taptinder/server/archive $TTROOT_DIR/file/archive
fi

# Config file 'conf/web_db.yml' createad by setup-mariadb.sh above.
cp conf/web_project.yml.example conf/web_project.yml
cp conf/web.yml.example conf/web.yml
cp $TTROOT_DIR/lib/config/main.example $TTROOT_DIR/lib/config/main
mkdir -p /tmp/taptinder /tmp/taptinder/uploads
chown -R taptinder:taptinder /tmp/taptinder /tmp/taptinder/uploads
chmod a-rwx,u+rwx /tmp/taptinder /tmp/taptinder/uploads
chmod -R a-rwx,u+r $TTCONF_DIR/*
chmod a-rwx,u+rwx $TTCONF_DIR

perl -Ilib t/01app.t
