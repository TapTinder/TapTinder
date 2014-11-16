#!perl

use strict;
use warnings;
use Carp qw(carp croak verbose);
use FindBin qw($RealBin);

use lib "$FindBin::Bin/../lib";
use TapTinder::DB;
use TapTinder::Utils::Conf qw(load_conf_multi);
use TapTinder::Utils::DB qw(get_connected_schema);

my $ver = 3;
my $req_fpath = $ARGV[0];
my $conf_dir = $ARGV[1] || $ENV{'TAPTINDER_SERVER_CONF_DIR'} || catdir( $RealBin, '..', 'conf');
my $conf = load_conf_multi( $conf_dir, 'db' );

my $schema = get_connected_schema( $conf->{db} );
croak "Connection to DB failed." unless $schema;

$schema->storage->txn_begin;

croak "First parameter should be perl input file path.\n" unless $req_fpath;
croak "Can't find input file '$req_fpath'.\n" unless -f $req_fpath;

my $rc = TapTinder::Utils::DB::run_perl_sql_file(
    $req_fpath,     # $req_fpath
    $schema,        # $schema
    1,              # $delete_old
    undef           # data
);


if ( $rc ) {
    print "Finished ok. Doing commit.\n" if $ver >= 3;
    $schema->storage->txn_commit;
} else {
    print "Error. Doing rollback.\n" if $ver >= 2;
    $schema->storage->txn_rollback;
}