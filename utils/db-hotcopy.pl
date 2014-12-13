#!/usr/bin/env perl

=pod

Warning! Stop server or all clients on ttcopy instance before starting 
this script.

This script is using mk-parallel-dump and mk-parallel-restore 
L<http://www.maatkit.org/doc/> to copy data from one database 
to another one. It is used to copy production data to development/copy 
database.

=cut

$| = 1;

use strict;
use warnings;

use Carp qw(carp croak verbose);
use FindBin qw($RealBin);

use YAML;
use File::Spec::Functions;

use lib "$RealBin/../lib";
use TapTinder::Utils::Cmd qw(run_cmd_ipc);
use TapTinder::Utils::DB;


sub dbutil_parallen_dump {
    my ( $src_conf, $dest_conf, $hotcopy_conf, $dump_path ) = @_;

    unless ( -d $dump_path ) {
        print "Creating directory '$dump_path'.\n";
        mkdir($dump_path) or return 0;
    }

    my $cmd_dump = 'mk-parallel-dump';
    $cmd_dump .= " --databases '" . $src_conf->{db}->{name} . "'";
    $cmd_dump .= " --user '" . $src_conf->{db}->{user} . "'";
    $cmd_dump .= " --password '" . $src_conf->{db}->{pass} . "'";
    $cmd_dump .= " --base-dir '" . $dump_path . "'";
    $cmd_dump .= " --threads 4";
    $cmd_dump .= " --lock-tables --chunk-size 500k";
    #print "cmd_dump: $cmd_dump\n";

    print "Running mk-parallel-dump '$src_conf->{db}->{name}' -> '$dump_path':\n";
    my $dump_rc = TapTinder::Utils::Cmd::run_cmd_ipc( $cmd_dump, 1, undef );
    return $dump_rc;
}


sub dbutil_parallen_restore {
    my ( $src_conf, $dest_conf, $hotcopy_conf, $dump_path ) = @_;

    croak "Dump directory '$dump_path' not found.\n" unless -d $dump_path;

    my $cmd_dump = 'mk-parallel-restore';
    $cmd_dump .= " --create-databases --database '" . $dest_conf->{db}->{name} . "'";
    $cmd_dump .= " --user '" . $hotcopy_conf->{user} . "'";
    $cmd_dump .= " --password '" . $hotcopy_conf->{pass} . "'";
    $cmd_dump .= " --base-dir '" . $dump_path . "'";
    $cmd_dump .= " --threads 4";
    $cmd_dump .= " --tab --fast-index";
    $cmd_dump .= " '$dump_path'";
    #print "cmd_dump: $cmd_dump\n";

    print "Running mk-parallel-restore '$dump_path' -> '$dest_conf->{db}->{name}':\n";
    my $dump_rc = TapTinder::Utils::Cmd::run_cmd_ipc( $cmd_dump, 1, undef );
    return $dump_rc;
}


my $src_conf_fpath  = $ARGV[0] || catfile( $RealBin, '..', '..', '..', 'tt', 'server', 'conf', 'web_db.yml' );
croak "Source config file path not given." unless $src_conf_fpath;
croak "Source config file '$src_conf_fpath' not found." unless -f $src_conf_fpath;

my $dest_conf_fpath  = $ARGV[1] || catfile( $RealBin, '..', 'conf', 'web_db.yml' );
croak "Destination config file '$dest_conf_fpath' not found." unless -f $dest_conf_fpath;

my $hotcopy_conf_fpath  = $ARGV[1] || catfile( $RealBin, '..', 'conf', 'hotcopy.yml' );
croak "Hotcopy credential config file '$hotcopy_conf_fpath' not found." unless -f $hotcopy_conf_fpath;

my ( $src_conf ) = YAML::LoadFile( $src_conf_fpath );
croak "Configuration for source database loaded from '$src_conf_fpath' is empty.\n" unless $src_conf->{db};

my ( $dest_conf ) = YAML::LoadFile( $dest_conf_fpath );
croak "Configuration for destination database loaded from '$dest_conf_fpath' is empty.\n" unless $dest_conf->{db};

my ( $hotcopy_conf ) = YAML::LoadFile( $hotcopy_conf_fpath );
croak "Configuration for destination database loaded from '$hotcopy_conf_fpath' is empty.\n" unless $hotcopy_conf->{user};


# Try to save from fatal misuse.
if ( 1 ) {
    my $dest_schema = get_connected_schema( $dest_conf->{db} );
    my $instance_params_rs = $dest_schema->resultset('param')->search({
        'param_type_id' => 2, # delete all old 'instance-name' rows
    });
    while ( my $row = $instance_params_rs->next ) {
        my $instance_name = $row->get_column('value');
        if ( $instance_name ne 'ttcopy' ) {
            croak "Check destination database failed. Parameter 'instance-name' has value '$instance_name' (value 'ttcopy' required)";
        }
    }
}



my $rc = undef;

# Dump and restore.
if ( 1 ) {

    # Dump.
    my $dest_dpath = catdir( $RealBin, '..', 'temp', 'db-dump-' . $src_conf->{db}->{name} );
    $rc = dbutil_parallen_dump( $src_conf, $dest_conf, $hotcopy_conf, $dest_dpath );
    unless ( $rc ) {
        croak "dbutil_parallen_dump failed.";
    }

    # Restore.
    $rc = dbutil_parallen_restore( $src_conf, $dest_conf, $hotcopy_conf, $dest_dpath );
    unless ( $rc ) {
        croak "dbutil_parallen_restore failed.";
    }
}


# Update some data to finish ttcopy instance.
if ( 1 ) {
    my $base_fname = 'data-copy-after-hotcopy';
    my $after_copy_sql_fpath = catfile( $RealBin, '..', 'sql', $base_fname.'.pl' );

    my $dest_schema = get_connected_schema( $dest_conf->{db} );
    croak "Connection to destination DB failed." unless $dest_schema;
    $rc = TapTinder::Utils::DB::run_perl_sql_file_trans( $after_copy_sql_fpath, $dest_schema );
    print "After hotcopy script return code: $rc\n";
}
