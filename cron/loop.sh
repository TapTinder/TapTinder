#!/bin/sh

for ((i=1;1;i++)); do
	echo "Run number: " $i
	date
	echo ""

	echo "Repository update:"
	nice -n 10 perl repository-update.pl --project=parrot

	sleep 5
	nice -n 10 perl repository-update.pl --project=rakudo
	echo ""

	#echo "Tests to DB:"
	#nice -n 10 perl tests-to-db.pl --limit=10 --ver=2
	#echo ""

	echo "Sleeping for 15 s ..."
	sleep 15

	echo ""
	echo ""
done
