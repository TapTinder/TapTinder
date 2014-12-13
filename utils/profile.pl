#!/usr/bin/env perl

use strict;
use warnings;
use Carp qw(carp croak verbose);
use FindBin qw($RealBin);

use Getopt::Long;
use Pod::Usage;

use Time::HiRes qw(time sleep);
use Data::Dumper;

use lib "$FindBin::Bin/../lib";
use TapTinder::DB;
use TapTinder::Utils::Conf qw(load_conf_multi);
use TapTinder::Utils::DB qw(get_connected_schema);

my $help = 0;
my $ver = 2;
my $options_ok = GetOptions(
    'help|h|?' => \$help,
    'ver|v=i' => \$ver,
);
pod2usage(1) if $help || !$options_ok;

my $conf = load_conf_multi( undef, 'db' );
croak "Configuration for database is empty.\n" unless $conf->{db};

my $schema = get_connected_schema( $conf->{db} );


sub to_profile {
    my ( $schema ) = @_;

    # load make results
    my $plus_rows = [ qw/ machine_id rev_id status_id status_name web_fpath /];
    my $search_conf = {
        'select' => $plus_rows,
        'as'     => $plus_rows,
        bind   => [
            1, # $rep_path_id, # rep_path_id
            40500, #$rev_num_from, # rev_num
        ],
        result_class => 'DBIx::Class::ResultClass::HashRefInflator',
    };

    my $rs = $schema->resultset( 'BuildStatus' )->search( {}, $search_conf );

    my @all_rows = $rs->all;
    return \@all_rows;
}


sub profile {
    my ( $schema ) = @_;

    DB::enable_profile();
    to_profile( @_ );
    DB::disable_profile();
}


sub profile_simple {
    my ( $schema ) = @_;

    my $time_start = time();

    my $all_rows = to_profile( @_ );
    print "rows: " . scalar( @$all_rows ) . "\n";
    #print Dumper( $all_rows );

    my $time_elapsed = time() - $time_start;
    return $time_elapsed;
}


if ( $ARGV[0] ) {
    my $time_elapsed = profile_simple( $schema );
    printf( "time_elapsed: %4.3f s\n", $time_elapsed );

} else {
    profile( $schema );
}



=head1 NAME

profile.pl - Profile SQL.

=head1 SYNOPSIS

perl profile.pl [options]

 Options:
   --help
   --ver=$NUM .. Verbosity level. Default 2.

=head1 DESCRIPTION

B<This program> ...

=cut
