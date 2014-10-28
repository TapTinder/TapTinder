#!/bin/bash

set -e
set -x

if [ "$1" = "base" ]; then
	:
elif [ "$1" = "schema" ]; then
	UPDATE_SCHEMA=1
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

echo -n "creating temp/schema-raw-create.sql - "
perl utils/wiki_schema.pl sql/schema.wiki 0 1 0 > temp/schema-raw-create.sql && echo done

if [ "$UPDATE_SCHEMA" ]; then
    echo -n "updating TapTinder::DB::Schema.pm - "
    perl utils/sqlt-taptinder.pl dbix temp/schema-raw-create.sql 0 && echo done
fi

echo -n "creating temp/schema-raw-create-comments.sql - "
perl utils/wiki_schema.pl sql/schema.wiki 0 1 1 > temp/schema-raw-create-comments.sql && echo done

if [ "$UPDATE_IMAGES" ]; then
    echo -n "updating temp/schema.png - "
    rm -rf temp/dbdoc/*
    perl utils/sqlt-taptinder.pl dbdoc temp/schema-raw-create-comments.sql 0 && echo done
fi


echo "Executing utils/deploy.pl --save"
perl ./utils/deploy.pl --save --conf_dir $CONF_DIR
echo ""
