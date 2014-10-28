#!perl

use strict;
use warnings;
use Carp qw(carp croak verbose);
use FindBin qw($RealBin);

use Getopt::Long;
use Pod::Usage;

use Data::Dumper;
use File::Spec::Functions;

use lib "$FindBin::Bin/../lib";
use TapTinder::DB;
use TapTinder::Utils::Conf qw(load_conf_multi);
use TapTinder::Utils::DB qw(get_connected_schema);

my $help = 0;
my $ver = 2;
my $opt_save = 0;
my $opt_drop = 0;
my $opt_deploy = 0;
my $opt_data = 0;
my $conf_dir = undef;
my $options_ok = GetOptions(
    'save' => \$opt_save,
    'drop' => \$opt_drop,
    'deploy' => \$opt_deploy,
    'data=s' => \$opt_data,
    'conf_dir=s' => \$conf_dir,
    'help|h|?' => \$help,
    'ver|v=i' => \$ver,
);

my $db_work = ( $opt_drop || $opt_deploy || $opt_data );
pod2usage(1) if $help || !$options_ok || ( !$opt_save && !$db_work );

my $conf = load_conf_multi( $conf_dir, 'db' );
croak "Configuration for database is empty.\n" unless $conf->{db};

my $schema = get_connected_schema( $conf->{db} );
croak "Connection to DB failed." unless $schema;

if ( $opt_save ) {
    my $ddl_dir = catdir( $RealBin, '..', 'temp', 'deploy-ddl' );
    unless ( -d $ddl_dir ) {
        mkdir $ddl_dir or croak $!;
    }

    my $drop_sql = TapTinder::Utils::DB::get_drop_all_existing_tables_sql( $schema );
    my $drop_sql_fpath = catfile( $ddl_dir, 'drop-all-tables.sql' );
    my $fh;
    open( $fh, '>'.$drop_sql_fpath ) || croak $!;
    print $fh $drop_sql;
    close $fh;

    $schema->create_ddl_dir('MySQL', undef, $ddl_dir);

    print "DDL files saved to $ddl_dir\n" if $ver >= 2;
}


if ( $db_work ) {
    $schema->storage->txn_begin;
}

if ( $opt_drop ) {
    my $rc = TapTinder::Utils::DB::do_drop_all_existing_tables( $schema );
}

if ( $opt_deploy ) {
    $schema->deploy();
}


if ( $opt_data ) {

    my $base_data = {};
    $base_data->{db_version} = '0.5';
    my $req_fname = 'data-base.pl';
    my $req_fpath = catdir( $RealBin, '..', 'sql', $req_fname );
    TapTinder::Utils::DB::run_perl_sql_file(
        $req_fpath,     # $req_fpath
        $schema,        # $schema
        1,              # $delete_old
        $base_data      # data
    );

    $req_fname = 'data-' . $opt_data . '.pl';
    $req_fpath = catdir( $RealBin, '..', 'sql', $req_fname );
    TapTinder::Utils::DB::run_perl_sql_file(
        $req_fpath,     # $req_fpath
        $schema,        # $schema
        1,              # $delete_old
        undef           # data
    );
}


if ( $db_work ) {
    $schema->storage->txn_commit;
}



=head1 NAME

deploy - Deploy utility.

=head1 SYNOPSIS

perl deploy.pl [options]

 Options:
   --save .. Save ddl files to temp/deploy-ddl.
   --drop .. Drop all existing tables.
   --deploy .. Deploy new schema.
   --data=prod .. Insert production data.
   --data=dev .. Insert devel data.
   --help
   --ver=$NUM .. Verbosity level. Default 2.

=head1 DESCRIPTION

B<This program> will ...

=cut
