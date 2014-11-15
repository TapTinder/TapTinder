use strict;
use warnings;

use Carp qw(carp croak verbose);
use FindBin qw($RealBin);

use lib "$RealBin/../lib";
use SQL::Translator;
use SQL::Translator::Utils::GenDoc qw/produce_db_doc/;

use Data::Dumper;


sub mdump {
    my $dumper = Data::Dumper->new( \@_ );
    $dumper->Purity(1)->Terse(1)->Deepcopy(1);
    print $dumper->Dump;
}

my $to = $ARGV[0] || 'dbix';
my $input_file = $ARGV[1] || './temp/schema-raw-create.sql';
my $dbdoc_out_dir = $ARGV[2];
my $ver = $ARGV[3];
$ver = 3 unless defined $ver;

my $producer_prefix = 'TapTinder::DB::Schema';
my $producer_base_class_name = 'TapTinder::DB::DBIxClassBase';
my $table_name_url_prefix = 'http://dev.taptinder.org/wiki/DB_Schema#';

print "Runnig translator to '$to' for input file '$input_file' (ver $ver).\n" if $ver >= 3;

croak "Input file '$input_file' not found." unless -f $input_file;


# package - DBIx::Class - .pm
if ( $to eq 'dbix' || $to eq 'ALL' ) {
    my $translator = SQL::Translator->new(
        filename  => $input_file,
        parser    => 'MySQL',
        producer  => 'DBIx::Class::FileMJ',
        producer_args => {
            prefix => $producer_prefix,
            base_class_name => $producer_base_class_name,
        },
    ) or croak SQL::Translator->error;

    my $out_fn = './lib/TapTinder/DB/Schema.pm';
    my $content = $translator->translate;

    croak $translator->error if $translator->error;

    if ( $content ) {
        my $fh;
        open ( $fh, '>', $out_fn ) || die $!;
        print $fh $content;
        close $fh;
    }


# database documentation (schema and schema parts with GraphViz)
} elsif ( $to eq 'dbdoc' || $to eq 'ALL' ) {
    produce_db_doc(
        $ver,
        $input_file,
        $table_name_url_prefix,
        $dbdoc_out_dir
    );

# TODO - use AutoDia?
# dia - DiaUml - .xml
} elsif ( $to eq 'dia' ) { # || $to eq 'ALL'
    my $translator = SQL::Translator->new(
        filename       => $input_file,
        from           => 'MySQL',
        to             => 'DiaUml',
    ) or die SQL::Translator->error;

}
