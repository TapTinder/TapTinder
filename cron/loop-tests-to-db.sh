#!/bin/bash

for ((i=1;1;i++)); do
	perl tests-to-db.pl
	echo "Sleeping for 30 s ..."
	sleep 30
done
