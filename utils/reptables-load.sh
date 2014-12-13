#!/bin/sh

echo "Executing temp/reptables-dump.sql (perl utils/db-run-sqlscript.pl ...):"
perl ./utils/db-run-sqlscript.pl ./temp/reptables-dump.sql 1
