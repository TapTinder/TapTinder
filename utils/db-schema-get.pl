use strict;
use warnings;

use Carp qw(carp croak verbose);
use FindBin qw($RealBin);
use Data::Dumper;

use SQL::Translator;
use SQL::Translator::Parser::DBI::MySQL; # SQL::Translator bug bypass.
use File::Spec::Functions;
use YAML;

my $debug = 0;

my $conf_dir = $ENV{'TAPTINDER_SERVER_CONF_DIR'} || catdir( $RealBin, '..', 'conf');
my $conf_fpath = catfile($conf_dir, 'web_db.yml');
my ( $conf ) = YAML::LoadFile( $conf_fpath );
croak "Configuration for database loaded from '$conf_fpath' is empty.\n" unless $conf->{db};

my $translator  =  SQL::Translator->new(
    parser => 'DBI',
    parser_args => {
        dsn => $conf->{db}->{dbi_dsn},
        db_user => $conf->{db}->{user},
        db_password => $conf->{db}->{pass},
    },
    producer => 'MySQL',
    debug => $debug,
) or croak SQL::Translator->error;

my $out_fname = $conf->{db}->{name} . '-online-schema.sql';
my $out_fpath = catfile( $RealBin, '..', 'temp', $out_fname );

my $content = $translator->translate;
croak $translator->error unless $content;

my $fh;
open ( $fh, '>', $out_fpath ) || croak $!;
print $fh $content;
close $fh;
