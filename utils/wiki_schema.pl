#!/usr/bin/env perl

# server> perl utils/wiki_schema.pl sql/schema.wiki 1 1 > sql/schema.sql
# server> perl utils/wiki_schema.pl sql/schema.wiki 0 1 trun > temp/table-trun.sql

use strict;
use warnings;

use Carp qw(carp croak verbose);


sub slurp_file {
    my $fp = shift;
    open( my $fh, '<', $fp ) or croak $!;
    local $/ = undef;
    return <$fh>;
}


sub get_sources {
    my ( $text, $part_name, $rh_source_types, $debug ) = @_;

    my $line_num = 1;
    my $res;
    my $part_level = 0;
    my @source_level = ();
    my $res_text = '';
    my $new_source_part = 0;

    PARSER: {
        if ( $text =~ /\G( \<\!\-\-\s*PARSE\s+PART\s+(\S+?)\s+(BEGIN|END)\s*\-\-\> )/gscx )
        {
            my $full_c = $1;
            my $type = $2;
            my $begin_end = $3;
            if ( $begin_end eq 'BEGIN' ) {
                $part_level++;
            }
            else {
                $part_level--;
            }
            print "line_num: $line_num\n" if $debug > 1;
            print "  type: $type, begin_end: $begin_end\n" if $debug > 1;
            $line_num += ($full_c =~ tr/\n//);
            redo PARSER;
        }

        if ( $text =~ /\G( \<source\s+lang=\"*(\S+?)\"*\s*\>\s*\n? )/gscx ) {
            my $full_c = $1;
            my $source_type = $2;
            push @source_level, $source_type;
            $new_source_part = 1;
            print "line_num: $line_num, source begin: $source_type\n" if $debug > 1;
            print "  new levels: @source_level\n" if $debug && @source_level > 1;
            $line_num += ($full_c =~ tr/\n//);
            redo PARSER;
        }

        if ( $text =~ /\G( \<\/source\>\s*\n? )/gscx ) {
            my $full_c = $1;
            print "line_num: $line_num, source end\n" if $debug > 1;
            pop @source_level;
            print "  new levels: @source_level\n" if $debug > 1 && @source_level >= 1;
            $line_num += ($full_c =~ tr/\n//);
            redo PARSER;
        }

        if ( $text =~ /\G( [^\<]+ )/gscx || $text =~ /\G( . )/gscx ) {
            my $full_c = $1;
            print "line_num: $line_num\n" if $debug > 1;

            if ( $part_level && @source_level > 0 ) {
                #print $full_c if $debug > 1;
                if ( exists $rh_source_types->{ $source_level[-1] } ) {
                    if ( $new_source_part ) {
                        $res_text .= "\n\n" if $res_text ne '';
                        $res_text .= "-- line: $line_num\n" if $debug > 0;
                    }
                    $new_source_part = 0;
                    $res_text .= $full_c;
                    print "  OK\n" if $debug > 1;
                } else {
                    print "  SKIPPED\n" if $debug > 1;
                }
            }

            $line_num += ($full_c =~ tr/\n//);
            redo PARSER;
        }
    }

    print "\n\n" if $debug > 1;
    return $res_text;
}


sub get_table_list {
    my ( $text, $ra_sel_tables, $debug ) = @_;

    my $rh_sel_tables = undef;
    if ( scalar @$ra_sel_tables ) {
        $rh_sel_tables = {};
        $rh_sel_tables->{$_} = 0 foreach @$ra_sel_tables;
    }

    my $sel_sql = '';
    my @tables = ();
    PARSER: {
        if ( $text =~ /\G( CREATE \s+ TABLE \s+ `?(\S+?)`?\s+(.*?)\; )/gscx )
        {
            my $sql = $1;
            my $table = $2;
            print "$table" if $debug > 1;
            if ( defined $rh_sel_tables && not exists $rh_sel_tables->{$table} ) {
                print " - skipped" if $debug > 1;
            } else {
                $rh_sel_tables->{$table}++ if defined $rh_sel_tables;
                push @tables, $table;
                $sel_sql .= "\n\n" if $sel_sql;
                $sel_sql .= $sql;
            }
            print "\n" if $debug > 1;
        }
        if ( $text =~ /\G( [^C]+ )/gscx ) {
            $sel_sql .= $1;
            redo PARSER;
        }
        if ( $text =~ /\G( . )/gscx ) {
            $sel_sql .= $1;
            redo PARSER;
        }
    }

    $sel_sql =~ s{\r}{}g;
    $sel_sql =~ s{\n\n\n+}{\n\n}g;

    if ( defined $rh_sel_tables ) {
        foreach my $table ( sort keys %$rh_sel_tables ) {
            my $num_found = $rh_sel_tables->{$table};
            if ( $num_found == 0 ) {
                print "-- ERROR: table '$table' not found.\n";
            } elsif ( $num_found > 1 ) {
                print "-- ERROR: found $num_found definitions for table '$table'.\n";
            }
        }
    }

    return ( \@tables, $sel_sql );
}


sub print_tables_for_sql {
    my ( $tables ) = @_;

    my $num = 0;
    foreach my $table ( sort @$tables ) {
        print ", " if $num > 0;
        print '`' . $table . '`';
        $num++;
    }
}


my $in_fpath = shift @ARGV || 'sql/schema.wiki';
my $debug = shift @ARGV;
$debug = 0 unless defined $debug;

my $conf = {};
$conf->{raw_create} = shift @ARGV;
$conf->{raw_create} = 0 unless defined $conf->{raw_create};

$conf->{raw_create_add_comments} = shift @ARGV;
$conf->{raw_create_add_comments} = 0 unless defined $conf->{raw_create_add_comments};

my @sel_tables = @ARGV;


my $content = slurp_file( $in_fpath );
my $create_sql = get_sources( $content, 'DBCREATE', { 'sql' => 1, }, $debug );

if ( $conf->{raw_create} ) {
    my $raw_sql = $create_sql;
    if ( $conf->{raw_create_add_comments} ) {
        $raw_sql =~ s{\/\*\s*(.*?)\s*\*\/}{,\n  $1}igs;
    } else {
        $raw_sql =~ s{\/\*\s*(.*?)\s*\*\/}{}igs;
    }
    $raw_sql =~ s{^.*?(CREATE.*)$}{$1}is;
    $raw_sql =~ s{^(.*CREATE[^\;]+;).*?$}{$1}is; # hmm
    print "$raw_sql\n";

} else {
    my ( $ra_tables, $sel_sql ) = get_table_list( $create_sql, \@sel_tables, $debug );

    print "-- Do not edit this file.\n";
    print "-- Generated from: '$in_fpath'";
    print "\n\n";

    print "-- table list:\n";
    print "-- ";
    print_tables_for_sql( $ra_tables );
    print "\n\n";

    print "-- Drop all tables:\n";
    #print "-- ";
    print "SET FOREIGN_KEY_CHECKS=0;\n";
    print "DROP TABLE IF EXISTS ";
    print_tables_for_sql( $ra_tables );
    print ";";
    print "\n\n";

    print "$sel_sql\n";
}
