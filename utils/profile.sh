#!/bin/bash

rm -rf ./nytprof/
mkdir ./nytprof/

# Source code
cp ./utils/profile.pl ./nytprof/profile.pl.txt
cp ./utils/profile.sh ./nytprof/profile.sh.txt


# DBIC_TRACE disable, NYTProf disabled
export -u NYTPROF
export -u DBIC_TRACE
perl ./utils/profile.pl 1 > ./nytprof/profile-out.txt


# DBIC_TRACE enabled, NYTProf disabled
export -u NYTPROF
export DBIC_TRACE="1=/tmp/tt-profile.out"
perl ./utils/profile.pl 1
cp /tmp/tt-profile.out ./nytprof/dbictrace.txt


# DBIC_TRACE disable, NYTProf enabled
export NYTPROF=trace=3:start=no
export -u DBIC_TRACE
perl -d:NYTProf ./utils/profile.pl 2>&1 1>nytprof-cmd-out.txt
cp ./nytprof.out ./nytprof/
nytprofhtml


# Original slow code:
cp ./lib/TapTinder/Web/Controller/BuildStatus.pm ./nytprof/


# My index.
cp ./utils/profile-index.html ./nytprof/myindex.html

