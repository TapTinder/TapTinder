#!/bin/sh

set -e
set -x

if [ "$1" = "base" ]; then
	:
elif [ "$1" = "schema" ]; then
	UPDATE_SCHEMA=1
elif [ "$1" = "images" ]; then
	UPDATE_IMAGES=1
elif [ "$1" = "schema-images" ]; then
	UPDATE_SCHEMA=1
	UPDATE_IMAGES=1
else
	echo "Unknown action. Allowed base|schema|schema-images."
fi

if [ "$2" ]; then
	CONF_DIR="$2"
else
	CONF_DIR='conf'
fi
if [ "$3" ]; then
	DDL_DIR="$3"
else
	DDL_DIR='temp/deploy-ddl'
	mkdir -p temp
	mkdir -p $DDL_DIR
fi
if [ "$4" ]; then
	DBDOC_DIR="$4"
else
	DBDOC_DIR='temp/dbdoc'
fi

echo -n "creating temp/schema-raw-create.sql - "
perl utils/wiki_schema.pl sql/schema.wiki 0 1 0 > $DDL_DIR/schema-raw-create.sql && echo done

if [ "$UPDATE_SCHEMA" ]; then
    echo -n "updating TapTinder::DB::Schema.pm - "
    perl utils/sqlt-taptinder.pl dbix $DDL_DIR/schema-raw-create.sql $DBDOC_DIR 0 && echo done
fi

echo -n "creating temp/schema-raw-create-comments.sql - "
perl utils/wiki_schema.pl sql/schema.wiki 0 1 1 > $DDL_DIR/schema-raw-create-comments.sql && echo done

if [ "$UPDATE_IMAGES" ]; then
    echo -n "updating temp/schema.png - "
    mkdir -p temp
    mkdir -p $DBDOC_DIR
    rm -rf $DBDOC_DIR/*
    perl utils/sqlt-taptinder.pl dbdoc $DDL_DIR/schema-raw-create-comments.sql $DBDOC_DIR 0 && echo done
fi


echo "Executing utils/deploy.pl --save"
perl ./utils/deploy.pl --save --conf_dir $CONF_DIR --ddl_dir $DDL_DIR
echo ""
