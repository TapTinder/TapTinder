#!/bin/sh

clear

echo "Going to change database to clear devel version. All data will be lost."
echo "Press <Enter> to continue or <Ctrl+C> to cancel ..."
read

echo "Are you sure? This is live productive version."
echo "Before you start:"
echo "* Stop all repository update loops."
echo ""
echo "This will be stoped automaticaly:"
echo "* FastCGI server"
echo ""
echo "Press <Enter> to continue or <Ctrl+C> to cancel ..."
read

echo "Stoping FastCGI processes"
utils/start-server.sh prod f stop
echo ""

echo "Running utils/all-sql.sh"
./utils/all-sql.sh $1
echo ""

echo "Executing utils/deploy.pl --drop --deploy --data=prod"
perl ./utils/deploy.pl --drop --deploy --data=prod
echo ""

echo "Copying temp/schema-raw-create.sql to temp/schema-raw-create-dump.sql"
cp ./temp/schema-raw-create.sql ./temp/schema-raw-create-dump.sql
echo ""

echo "Executing utils/set_client_passwd.pl --client_conf_fpath (perl):"
perl ./utils/set_client_passwd.pl --client_conf_fpath
echo ""

echo "Executing utils/set_client_passwd.pl --client_passwd_list (perl):"
perl ./utils/set_client_passwd.pl --client_passwd_list
echo ""

#echo "Executing utils/reptable-load.sh:"
#./utils/reptables-load.sh
#echo ""

echo "Executing cron/repository-update.pl --project=Parrot (perl):"
perl ./cron/repository-update.pl --project=parrot
echo ""

#echo "Executing cron/repository-update.pl --project=Parrot (perl):"
#perl ./cron/repository-update.pl --project=rakudo
#echo ""

echo "Executing utils/db-fill-sqldata.pl sql/data-prod-jobs.pl"
perl ./utils/db-fill-sqldata.pl ./sql/data-prod-jobs.pl
echo "";
        
echo "Executing utils/rm_uploaded_files.pl --remove (perl):"
perl ./utils/rm_uploaded_files.pl --remove
echo ""

echo "Starting FastCGI processes"
utils/start-server.sh prod f start
echo ""

echo "Done."
