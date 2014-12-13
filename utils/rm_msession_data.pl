#!/usr/bin/env perl

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
my $sel_msession_id = undef;
my $sel_machine_id = undef;
my $sel_msproc_id = undef;
my $sel_msjob_id = undef;
my $sel_trun_id = undef;
my $options_ok = GetOptions(
    'help|h|?' => \$help,
    'ver|v=i' => \$ver,
    'trun_id=i' => \$sel_trun_id,
    'msjob_id=i' => \$sel_msjob_id,
    'msproc_id=i' => \$sel_msproc_id,
    'msession_id=i' => \$sel_msession_id,
    'machine_id=i' => \$sel_machine_id,
);
pod2usage(1) if $help || !$options_ok;
if (    (not defined $sel_machine_id)
     && (not defined $sel_msession_id)
     && (not defined $sel_msproc_id)
     && (not defined $sel_msjob_id)
     && (not defined $sel_trun_id)
   )
{
    print "No machine_id, msession_id, msproc_id, msjob_id or trun_id selected.\n";
    pod2usage(1);
}

my $conf = load_conf_multi( undef, 'db' );
croak "Configuration for database is empty.\n" unless $conf->{db};

my $schema = get_connected_schema( $conf->{db} );

my $search_cond = {};
$search_cond->{'trun_id.trun_id'}         = $sel_trun_id if defined $sel_trun_id;
$search_cond->{'msjob_id.msjob_id'}       = $sel_msjob_id if defined $sel_msjob_id;
$search_cond->{'msproc_id.msproc_id'}     = $sel_msproc_id if defined $sel_msproc_id;
$search_cond->{'msession_id.msession_id'} = $sel_msession_id if defined $sel_msession_id;
$search_cond->{'msession_id.machine_id'}  = $sel_machine_id  if defined $sel_machine_id;

my $search_attrs = {};
my $table_name;

if ( defined $sel_trun_id ) {
    $table_name = 'trun';
} elsif ( defined $sel_msjob_id ) {
    $table_name = 'msjob';
} elsif ( defined $sel_msproc_id ) {
    $table_name = 'msproc';
} else {
    $table_name = 'msession';
}

$search_attrs = { 'alias' => $table_name.'_id', };
my $rs_msession = $schema->resultset($table_name)->search( $search_cond, $search_attrs );

my $found = 0;
while ( my $row = $rs_msession->next ) {
    $found = 1;
}

unless ( $found ) {
    print "No records found in table $table_name for ";

    my $id_str = '';
    if ( defined $sel_trun_id ) {
        print "trun_id=$sel_trun_id";
    }
    if ( defined $sel_msjob_id ) {
        print ", " if $id_str;
        print "msjob_id=$sel_msjob_id";
    }
    if ( defined $sel_msproc_id ) {
        print ", " if $id_str;
        print "msproc_id=$sel_msproc_id";
    }
    if ( defined $sel_msession_id ) {
        print ", " if $id_str;
        print "msession_id=$sel_msession_id";
    }
    if ( defined $sel_machine_id ) {
        print ", " if $id_str;
        print "machine_id=$sel_machine_id";
    }
    print ".\n";
    exit;
}


sub get_rs_for_my_attrs {
    my ( $schema, $search_cond, $conf ) = @_;

    my ( $table_name, $joins ) = @$conf;
    print "deleting from table: $table_name\n";
    $search_attrs = { alias => $table_name.'_id' };
    $search_attrs->{prefetch} = $joins if defined $joins;
    my $rs = $schema->resultset($table_name)->search( $search_cond, $search_attrs );
}


sub delete_fsfile {
    my ( $schema, $fsfile_id ) = @_;

    my $table_name = 'fsfile';
    my $row = $schema->resultset($table_name)->find(
        { 'fsfile_id.fsfile_id' => $fsfile_id, },
        {
            'select' => [ 'fsfile_id.fsfile_id', 'fspath_id.path', 'fsfile_id.name' ],
            'as' =>     [ 'fsfile_id', 'file_path', 'file_name' ],
            join => 'fspath_id',
            alias => $table_name.'_id',
        }
    );

    my $full_fpath = catfile( $row->get_column('file_path'), $row->get_column('file_name') );
    print "  deleting: '$full_fpath'\n";
    unlink( $full_fpath );
    $row->delete;
    return 1;
}


my @fsfile_ids_to_delete = ();
unless ( defined $sel_trun_id ) {
    my $files_conf = [ 
        'msjobp_cmd', 
        [ 'output_id',
          'outdata_id', 
          { 'msjobp_id' => { 'msjob_id' => { 'msproc_id' => 'msession_id' }, }, },
        ],
    ];
    my $rs = get_rs_for_my_attrs( $schema, $search_cond, $files_conf );

    # Prepare list of files to delete.
    while ( my $row = $rs->next ) {
        my $data = { $row->get_columns };
        if ( $data->{'output_id'} ) {
            push @fsfile_ids_to_delete, $data->{'output_id'};
        }
        if ( $data->{'outdata_id'} ) {
            push @fsfile_ids_to_delete, $data->{'outdata_id'};
        }
    }
}

my $all_confs = [
    [
        'ttest',
        { 'trun_id' => { 'msjobp_cmd_id' => { 'msjobp_id' => { 'msjob_id' => { 'msproc_id' => 'msession_id' }, }, }, }, },
    ], [
        'tfile',
        { 'trun_id' => { 'msjobp_cmd_id' => { 'msjobp_id' => { 'msjob_id' => { 'msproc_id' => 'msession_id' }, }, }, }, },
    ], [
        'trun',
        { 'msjobp_cmd_id' => { 'msjobp_id' => { 'msjob_id' => { 'msproc_id' => 'msession_id' }, }, }, },
    ],
];


unless ( defined $sel_trun_id ) {
    # Delete from msjob related tables.
    $all_confs = [
        @$all_confs,
        [
            'msjobp_cmd',
            { 'msjobp_id' => { 'msjob_id' => { 'msproc_id' => 'msession_id' }, }, },
        ], [
            'msjobp',
            { 'msjob_id' => { 'msproc_id' => 'msession_id' }, },
        ], [
            'msjob',
            { 'msproc_id' => 'msession_id' },
        ],
    ];

    # Delete from msproc related tables.
    unless ( defined $sel_msjob_id ) {
        $all_confs = [
            @$all_confs,
            [
                'msproc_log',
                { 'msproc_id' => 'msession_id' },
            ], [
                'msproc',
                'msession_id',
            ],
        ];

        # Delete from msession related tables.
        unless ( defined $sel_msproc_id ) {
            $all_confs = [
                @$all_confs,
                [
                    'mslog',
                    'msession_id',
                ], [
                    'mswatch_log',
                    'msession_id',
                ], [
                    'msession',
                    undef
                ],
            ];
        }
        
    }
}


# Delete direct data.
foreach my $conf_num ( 0..$#$all_confs ) {
    my $conf = $all_confs->[ $conf_num ];
    my $rs = get_rs_for_my_attrs( $schema, $search_cond, $conf );
    if ( $rs ) {
        $rs->delete_all;
    } else {
        print Dumper( $conf );
    }
}


unless ( defined $sel_trun_id ) {
    # Delete files.
    print "deleting from table: fsfile\n";
    foreach my $fsfile_id ( @fsfile_ids_to_delete ) {
        delete_fsfile( $schema, $fsfile_id );
    }
}


=head1 NAME

rm_msession_data.pl - Remove all data and files related to one or all machine sessions.

=head1 SYNOPSIS

perl tests-to-db.pl [options]

 Options:
   --help
   --ver=$NUM .. Verbosity level. Default 2.
   --trun_id=$ID .. Machine session test run id.
   --msjob_id=$ID .. Machine session job id.
   --msproc_id=$ID .. Machine session process id.
   --msession_id=$ID .. Machine session id.
   --machine_id=$ID .. Machine id.

=head1 DESCRIPTION

B<This program> will delete ..

=cut
