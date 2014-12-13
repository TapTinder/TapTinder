#!/bin/bash

echo "Executing sql/del-trun-tables.sql (perl utils/db-run-sqlscript.pl ...):"
perl ./utils/db-run-sqlscript.pl ./sql/del-trun-tables.sql 1
