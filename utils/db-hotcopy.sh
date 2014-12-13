#!/bin/sh

# tt -> ttcopy 
clear && \
cd /home/jurosz/copy-tt/server && \
rm -rf ./temp/db-dump-tt/ && \
time perl utils/db-hotcopy.pl && \
perl utils/set_client_passwd.pl --client_passwd_list && \
echo "Hotcopy tt -> ttcopy done ok."
