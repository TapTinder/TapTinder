#!/usr/bin/env perl

use strict;
use warnings;

use Carp qw(carp croak verbose);
use FindBin qw($RealBin);

use YAML;
use File::Spec::Functions;

use lib "$RealBin/../lib";
use TapTinder::Utils::Cmd qw(run_cmd_ipc);


my $src_conf_fpath  = $ARGV[0] || catfile( $RealBin, '..', 'conf', 'web_db.yml' );
my $use_root_passwd = $ARGV[2] || 0;
my $noipc = $ARGV[3] || 1;
# TODO dump_only load_only

croak "Source conf file '$src_conf_fpath' not found." unless -f $src_conf_fpath;

if ( $use_root_passwd && $noipc ) {
    croak "Parameters conflict: use_root_passwd=1 and noipc=1.\n";
}

my ( $src_conf ) = YAML::LoadFile( $src_conf_fpath );
croak "Configuration for source database loaded from '$src_conf_fpath' is empty.\n" unless $src_conf->{db};

my $dump_fpath = './temp/' . $src_conf->{db}->{name} . '-dump.sql';

my $cmd_dump = 'mysqldump';
$cmd_dump .= ' -u ' . $src_conf->{db}->{user} unless $use_root_passwd;
if ( $noipc ) {
    $cmd_dump .= " -p'" . $src_conf->{db}->{pass} . "'";
} else {
    $cmd_dump .= ' -p';
}
$cmd_dump .= ' ' . $src_conf->{db}->{name};
$cmd_dump .= ' > ' . $dump_fpath;

# TODO IPC version (no password on command line or process list)

#print "cmd_dump: '$cmd_dump'\n";

print "Dumping database '$src_conf->{db}->{name}':\n";
my $dump_msg = "Enter source database password for user '$src_conf->{db}->{user}': ";
my $dump_rc = TapTinder::Utils::Cmd::run_cmd_ipc( $cmd_dump, $noipc, $dump_msg );
