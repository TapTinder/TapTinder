#!/bin/bash

clear

if [ -z "$1" ]; then
    echo "Help:"
    echo "  clear-copy-dh.sh WHAT SCHEMA UPGRADE"
    echo " "
    echo "    WHAT "
    echo "       0 ... empty database, load repository tables from stable"
    echo "       1 ... copy using mysqlhotcopy"
    echo "       2 ... copy using myslqdump and import"
    echo " "
    echo "    SCHEMA"
    echo "       0 ... do not update schema files"
    echo "       1 ... update schema files"
    echo "       2 ... update schema files and schema images"
    echo " "
    echo "    UPGRADE"
    echo "       1 ... upgrade database schema"
    exit
fi

    
# WHAT 1/2

if [ "$1" = "0" ]; then
    echo "Going to create fresh database (product repository):"
    echo "Press <Enter> to continue or <Ctrl+C> to cancel ..."
    read
fi

if [ "$1" = "1" -o "$1" = "2" ]; then
    echo "Going to rewrite this database by another one:"
    echo "Press <Enter> to continue or <Ctrl+C> to cancel ..."
    read
fi


# SCHEMA

if [ "$2" = "1" -o "$2" = "2" ]; then
	echo "Running utils/all-sql.sh"
	./utils/all-sql.sh $2
	echo ""
fi


# WHAT 2/2

if [ "$1" = "0" ]; then
    echo "Executing temp/all-stable.sql (perl utils/db-run-sqlscript.pl):"
    perl ./utils/db-run-sqlscript.pl ./temp/all-stable.sql 1
    echo ""

    echo "Copying temp/schema-raw-create.sql to temp/schema-raw-create-dump.sql"
    cp ./temp/schema-raw-create.sql ./temp/schema-raw-create-dump.sql
    echo ""
fi


if [ "$1" = "1" ]; then
	echo "Copying database with mysqlhotcopy (perl utils/db-hotcopy.pl ... ):"
	perl ./utils/db-hotcopy.pl ./../../tt/server/conf/web_db.yml
	echo ""
fi


if [ "$1" = "2" ]; then
	echo "Dumping DB (perl utils/db-dump.pl ... ):"
	perl ./utils/db-dump.pl ./../../tt/server/conf/web_db.yml
	echo ""

	echo "Running utils/all-sql.sh"
	./utils/all-sql.sh $2
	echo ""

	echo "Loading DB dump temp/tt-dump.sql (perl utils/db-run-sqlscript.pl ...):"
	perl ./utils/db-run-sqlscript.pl ./temp/tt-dump.sql 1
	echo ""
fi


# set client passwords
	
echo "Executing utils/set_client_passwd.pl --client_conf_fpath (perl):"
perl ./utils/set_client_passwd.pl --client_conf_fpath
echo ""

echo "Executing utils/set_client_passwd.pl --client_passwd_list (perl):"
perl ./utils/set_client_passwd.pl --client_passwd_list
echo ""


# repository tables export/import

if [ "$1" = "0" ]; then
    echo "Dumping and loading rep data:"
    ./utils/reptables-dump.sh
    cp ./temp/tables-dump.sql ./temp/reptables-dump.sql
    ./utils/reptables-load.sh
    echo ""
fi


# UPGRADE

if [ "$3" = "1" ]; then
	echo "Updating temp/ttcopy-online-schema.sql:"
	perl ./utils/db-schema-get.pl
	echo ""

	echo "Creating temp/schema-diff.sql:"
	sqlt-diff ./temp/ttcopy-online-schema.sql=MySQL temp/schema-raw-create.sql=MySQL > ./temp/schema-diff.sql
	echo ""

	echo "Executing temp/schema-diff.sql (perl utils/db-run-sqlscript.pl ...):"
	perl ./utils/db-run-sqlscript.pl ./temp/schema-diff.sql 1
	echo ""
fi


# stable to copy cleanup

echo "Executing sql/data-after-copied.sql (perl utils/db-run-sqlscript.pl):"
perl ./utils/db-run-sqlscript.pl ./sql/data-after-copied.sql 1
echo ""

echo "Executing utils/rm_uploaded_files.pl --remove --fspath_ids=4,5,6 (perl):"
perl ./utils/rm_uploaded_files.pl --remove --fspath_ids=4,5,6
echo ""

echo "Done."
