#!/usr/bin/env perl

use strict;
use warnings;

use Carp qw(carp croak verbose);
use FindBin qw($RealBin);

use DBI;
use YAML;
use File::Spec::Functions;

use lib "$RealBin/../lib";
use TapTinder::Utils::Cmd qw(run_cmd_ipc);


my $sql_fpath = $ARGV[0] || undef;
my $noipc = $ARGV[1] || 0;

croak "SQL file path not given" unless defined $sql_fpath;
croak "SQL file '$sql_fpath' not found" unless -f $sql_fpath;

my $conf_dir = $ENV{'TAPTINDER_SERVER_CONF_DIR'} || catdir( $RealBin, '..', 'conf');
my $conf_fpath = catfile($conf_dir, 'web_db.yml');
my ( $conf ) = YAML::LoadFile( $conf_fpath );
croak "Configuration for database loaded from '$conf_fpath' is empty.\n" unless $conf->{db};

croak "Database name not found.\n" unless $conf->{db}->{name};
croak "Database user name not found.\n" unless $conf->{db}->{user};
croak "Database user password not found.\n" unless $conf->{db}->{pass};

my $cmd = 'mysql -u ' . $conf->{db}->{user};
if ( $noipc ) {
    $cmd .= " -p'" . $conf->{db}->{pass} . "'";
} else {
    $cmd .= ' -p';
}
$cmd .= ' ' . $conf->{db}->{name};
$cmd .= ' < ' . $sql_fpath;
#print "cmd: '$cmd'\n";

# TODO IPC version (no password on command line or process list)

print "Running SQL file on database '$conf->{db}->{name}':\n";
my $msg = "Enter database password for user '$conf->{db}->{user}': ";
TapTinder::Utils::Cmd::run_cmd_ipc( $cmd, $noipc, $msg );
