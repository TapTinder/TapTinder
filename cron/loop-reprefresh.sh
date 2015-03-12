#!/bin/sh

for ((i=1;1;i++)); do
	echo "Run number: " $i
	date
	echo ""

	echo "Repository update:"
	nice -n 10 perl reprefresh.pl

	echo "Sleeping for 30 s ..."
	sleep 30

	echo ""
	echo ""
done
