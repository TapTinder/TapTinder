#!/usr/bin/env perl

use DBI;
use strict;

use Carp qw(carp croak verbose);
use FindBin qw($RealBin);

use File::Spec::Functions;
use YAML;

my $sql_fpath = $ARGV[0] || undef;

my $conf_dir = $ENV{'TAPTINDER_SERVER_CONF_DIR'} || catdir( $RealBin, '..', 'conf');
my $conf_fpath = catfile($conf_dir, 'web_db.yml');
my ( $conf ) = YAML::LoadFile( $conf_fpath );
croak "Configuration for database loaded from '$conf_fpath' is empty.\n" unless $conf->{db};

my $dbh = DBI->connect(
    $conf->{db}->{dbi_dsn},
    $conf->{db}->{user},
    $conf->{db}->{pass},
    { RaiseError => 1, AutoCommit => 0 }
) or croak $DBI::errstr;

my $sql_cmd;
if ( $sql_fpath ) {
    croak "SQL file '$sql_fpath' not found." unless -f $sql_fpath;
    my $sql_fh;
    open($sql_fh, '<', $sql_fpath ) or croak "$!";
    {
        local $/ = undef;
        $sql_cmd = <$sql_fh>;
    }
    #print $sql_cmd;
    #croak;

} else {
    $sql_cmd = "
        SELECT machine_id, user_id, name, descr, ip,
               cpuarch, osname, archname, disabled, created,
               prev_machine_id
          FROM machine
         WHERE disabled=0
    ";
}

my $sth = $dbh->prepare($sql_cmd) or croak $dbh->errstr;
$sth->execute();
while ( my @row = $sth->fetchrow_array ) {
    print join(' | ',@row) . "\n";
}

$dbh->commit;
$dbh->disconnect;
