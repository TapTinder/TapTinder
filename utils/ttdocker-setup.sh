#!/bin/bash

set -e
set -x

echo -n "Working dir:"
pwd

TTCONF_DIR='/home/taptinder/tt-server/conf'

mkdir -p -m 0700 $TTCONF_DIR
chown taptinder:taptinder $TTCONF_DIR
touch $TTCONF_DIR/db.root-pass.conf
chown taptinder $TTCONF_DIR/db.root-pass.conf

utils/mysql-secure.sh $TTCONF_DIR/db.root-pass.conf regen secure
cd ../tt-server/
utils/setup-mariadb.sh docker db $TTCONF_DIR/db.root-pass.conf $TTCONF_DIR/web_db.yml

mkdir -p temp
echo "Running utils/all-sql.sh"
utils/all-sql.sh schema-images $TTCONF_DIR
#utils/all-sql.sh base $TTCONF_DIR
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

# Config file 'conf/web_db.yml' createad by setup-mariadb.sh above.
cp conf/web_project.yml.example conf/web_project.yml
cp conf/web.yml.example conf/web.yml
cp root/lib/config/main.example root/lib/config/main
mkdir -p /tmp/taptinder /tmp/taptinder/uploads
# chown -R taptinder:taptinder conf/ root/ /tmp/taptinder /tmp/taptinder/uploads
# chmod -R a-rwx,u+r conf/
# chmod u+rx,o-rwx conf/
# chmod u+rwx,o-rwx /tmp/taptinder /tmp/taptinder/uploads

perl -Ilib t/01app.t

chown -R taptinder:taptinder /var/log/mariadb
