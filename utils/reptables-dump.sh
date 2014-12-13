#!/bin/sh

echo "Executing utils/tables-dump.pl (perl utils/tables-dump.pl ... ):"
perl ./utils/tables-dump.pl "project rep rep_author rep_path rev rev_rep_path rep_file_change rep_file rep_file_change_from"
