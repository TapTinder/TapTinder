#!/bin/sh

clear

function echo_help {
cat <<USAGE_END
Usage:
  utils/clear-dev-db.sh c|l [u|uu] [ld]

  c ... create fresh
  l ... load data from temp/ttdev-dump.sql

  n ... do not update schema files
  u ... update schema files
  uu ... update schema files, update dbdoc
  
  ld ... load test repositories
  la ... load test, Parrot and Rakudo repositories
  
Example:
  utils/clear-dev-db.sh c 
  utils/clear-dev-db.sh c uu ld

USAGE_END
}


if [ -z "$1" ]; then
    echo_help
    exit
fi


if [ "$1" = "l" ]; then
    echo "Going to rewrite database from dump. All new data will be lost."
    echo "Press <Enter> to continue or <Ctrl+C> to cancel ..."
    read

    if [ "$2" = "u" ]; then
        echo "Running utils/all-sql.sh 1"
        ./utils/all-sql.sh 1
        echo ""
    fi
    if [ "$2" = "uu" ]; then
        echo "Running utils/all-sql.sh 2"
        ./utils/all-sql.sh 2
        echo ""
    fi

    echo "Loading DB dump temp/tt-dump.sql (perl utils/db-run-sqlscript.pl ...):"
    perl ./utils/db-run-sqlscript.pl ./temp/ttdev-dump.sql 1
    echo ""

    echo "Executing utils/set_client_passwd.pl --client_conf_fpath --client_section_name=dev (perl):"
    perl ./utils/set_client_passwd.pl --client_conf_fpath --client_section_name=dev
    echo ""

    echo "Executing utils/set_client_passwd.pl --client_passwd_list (perl):"
    perl ./utils/set_client_passwd.pl --client_passwd_list
    echo ""

    if [ "$2" = "1" -o "$2" = "2" ]; then
        echo "Creating temp/schema-diff.sql:"
        sqlt-diff ./temp/schema-raw-create-dump.sql=MySQL temp/schema-raw-create.sql=MySQL > ./temp/schema-diff.sql
        echo ""

        echo "Executing temp/schema-diff.sql (perl utils/db-run-sqlscript.pl ...):"
        perl ./utils/db-run-sqlscript.pl ./temp/schema-diff.sql 1
        echo ""
    fi
fi

if [ "$1" = "c" ]; then

    echo "Going to change database to clear devel version. All data will be lost."
    echo "Press <Enter> to continue or <Ctrl+C> to cancel ..."
    read

    if [ "$2" = "u" ]; then
        echo "Running utils/all-sql.sh 1"
        ./utils/all-sql.sh 1
        echo ""
    fi
    if [ "$2" = "uu" ]; then
        echo "Running utils/all-sql.sh 2"
        ./utils/all-sql.sh 2
        echo ""
    fi

    echo "Executing utils/deploy.pl --drop --deploy --data=dev"
    perl ./utils/deploy.pl --drop --deploy --data=dev
    echo ""

    echo "Executing utils/set_client_passwd.pl --client_conf_fpath --$client_section_name=dev (perl):"
    perl ./utils/set_client_passwd.pl --client_conf_fpath --client_section_name=dev
    echo ""

	if [ -f 'conf/client-passwds.yml' ]; then
	  echo "Executing utils/set_client_passwd.pl --client_passwd_list (perl):"
	  perl ./utils/set_client_passwd.pl --client_passwd_list
	  echo ""
	fi

    echo "Executing utils/rm_uploaded_files.pl --remove (perl):"
    perl ./utils/rm_uploaded_files.pl --remove
    echo ""

    if [ "$3" = "ld" -o "$3" = "la" ]; then
        echo "Executing cron/repository-update.pl -p tt-tr1 (perl):"
        perl ./cron/repository-update.pl --ver=3 --project=tt-tr1
        echo ""
        echo "Executing cron/repository-update.pl -p tt-tr2 (perl):"
        perl ./cron/repository-update.pl --ver=3 --project=tt-tr2
        echo ""
        echo "Executing cron/repository-update.pl -p tt-tr3 (perl):"
        perl ./cron/repository-update.pl --ver=3 --project=tt-tr3
        echo "";

        if [ "$3" = "la" ]; then
            echo "Executing cron/repository-update.pl -p parrot (perl):"
            perl ./cron/repository-update.pl --ver=3 --project=parrot
            echo ""
            echo "Executing cron/repository-update.pl -p rakudo (perl):"
            perl ./cron/repository-update.pl --ver=3 --project=rakudo
            echo "";
        fi

        echo "Executing utils/db-fill-sqldata.pl sql/data-dev-jobs.pl"
        perl ./utils/db-fill-sqldata.pl ./sql/data-dev-jobs.pl
        echo "";
    fi
fi

echo "Done."
