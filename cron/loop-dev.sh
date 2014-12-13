#!/bin/sh

for ((i=1;1;i++)); do
	echo "Run number: " $i
	date
	echo ""
	nice -n 10 perl repository-update.pl --project tt-tr1
	sleep 5
	nice -n 10 perl repository-update.pl --project tt-tr2
	sleep 5
	nice -n 10 perl repository-update.pl --project tt-tr3
	echo "Sleeping for 300 s ..."
	sleep 300
	echo ""
	echo ""
done
