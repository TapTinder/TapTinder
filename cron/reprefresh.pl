#!/usr/bin/env perl

=pod

ToDo
* add tests
** https://github.com/mj41/TapTinder/issues#issue/25
* speed up
** initil parrot to DB takes 15 minutes

=cut

use strict;
use warnings;
use FindBin qw($RealBin);

use Getopt::Long;
use Pod::Usage;
use Carp qw(carp croak verbose);

use lib "$FindBin::Bin/../lib";
use TapTinder::Utils::Conf qw(load_conf_multi);
use TapTinder::Utils::DB qw(get_connected_schema do_dbh_sql get_dbh_errstr);

use lib "$FindBin::Bin/../third-party/Git-Repository-LogRaw/lib";
use TapTinder::Worker::RepRefresh;


my $help = 0;
my $project_name = undef;
my $verbose_level = 2;
my $debug_logpart = 0;
my $steps_str = undef;
my $options_ok = GetOptions(
	'help|h|?' => \$help,
	'project|p=s' => \$project_name,
	'verbose_level|vl=i' => \$verbose_level,
	'steps=s' => \$steps_str,
);
pod2usage(1) if $help || !$options_ok;

sub option_fatal_err {
	my ( $msg ) = @_;
	print $msg . "\n\n"  if $verbose_level >= 1;
	pod2usage(1);
	exit 0;
}

my $conf_dir = $ENV{'TAPTINDER_SERVER_CONF_DIR'} || catdir( $RealBin, '..', 'conf');
my $conf = load_conf_multi( $conf_dir, 'db' );
croak "Configuration for database is empty.\n" unless $conf->{db};
print "Connecting to DB.\n" if $verbose_level >= 3;
my $schema = get_connected_schema( $conf->{db} );
croak "Connection to DB failed." unless $schema;

my $rr_obj = TapTinder::Worker::RepRefresh->new(
	verbose_level => $verbose_level,
	schema => $schema,
	project_name => $project_name,
	steps_str => $steps_str,
);

$rr_obj->run();

=head1 NAME

reprefresh.pl - Clone/fetch repository, parse logs and push new data to DB.

=head1 SYNOPSIS

repository-update.pl -p project_name [options]

 Options:
   --help
   --verbose_level=%d .. Verbose level (default 2).
   --project=%s .. Project name.
   --steps=%s .. Steps to run (default --step=pull,commits,refs).

=head1 DESCRIPTION

B<This program> will clone/pull repository and fill/update related database tables.

=cut
