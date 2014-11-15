package SQL::Translator::Utils::GenDoc;

# ABSTRACT: Generate database schema images.

use Exporter;
use base qw(Exporter);

@EXPORT_OK = qw(produce_db_doc);


sub produce_db_doc {
    my ( $ver, $input_file, $table_name_url_prefix, $out_dir ) = @_;
	die "Directory '$out_dir' doesn't exist.\n" unless -d $out_dir;

    my $translator = SQL::Translator->new(
        parser    => 'MySQL',
        filename  => $input_file,
    ) or die SQL::Translator->error;

    # Mined from $translator->translate method
    my $data = $translator->data;
    $translator->parser->( $translator, $$data );

    # Invoke an anonymous subroutine directly
    my $schema = $translator->schema;
    my @tables = $schema->get_tables;

    # Get tags and tags shortcuts for tables.
    my $tags_tables = {};
    my $tags_shortcuts = {};
    foreach my $table ( @tables ) {
        my $comment = $table->comments;
        my $table_name = $table->name;

        print "Table '$table_name' found.\n" if $ver >= 3;
        print "  comment: '$comment'\n" if $ver >= 4;
        my @tags = ();
        my $found = 0;
        if ( my ( $tags_part ) = $comment =~ m/ Tag\: \s* ([^\.]+) \s* (?:\.|$) /isx ) {
            print "  tags str: '$tags_part'\n" if $ver >= 4;
            my @raw_tags = split( ',', $tags_part );
            print '  raw: ' . join(', ', @raw_tags ) . "\n" if $ver >= 4;
            foreach my $tag ( @raw_tags ) {
                $tag =~ s/^\s+//;
                $tag =~ s/\s+$//;
                $tags_tables->{ $tag } = [] unless exists $tags_tables->{ $tag };
                $found = 1;
                push @{ $tags_tables->{ $tag } }, $table_name;
            }
        }

        print "  found: $found\n" if $ver >= 4;
        unless ( $found ) {
            my $tag = '_no_tags';
            push @{ $tags_tables->{ $tag } }, $table_name;
        }

        print "\n" if $ver >= 4;
    }
    #mdump( $tags_tables ); exit;


    my $tag_colors = [
        [ qw/ Moccasin burlywood4 / ],
        [ qw/ BurlyWood SaddleBrown / ],
        [ qw/ YellowGreen darkgoldenrod4 / ],
        [ qw/ cadetblue cadetblue4 / ],
        [ qw/ LightCoral FireBrick / ],
        [ qw/ LightSalmon Crimson / ],
        [ qw/ Pink DeepPink / ],
        [ qw/ Coral OrangeRed / ],
        [ qw/ Khaki brown4 / ],
        [ qw/ RoyalBlue MidnightBlue / ],
        [ qw/ Plum deeppink4 / ],
        [ qw/ PaleGreen LimeGreen / ],
        [ qw/ PaleTurquoise dodgerblue3 / ],
        [ qw/ Grey DimGray / ],
        [ qw/ MistyRose Orchid / ],
    ];


    my $all_clusters = [];
    my $tag_num = 0;
    foreach my $tag ( keys %$tags_tables ) {
        push @$all_clusters, {
            name => $tag,
            tables => $tags_tables->{ $tag },
            colors => $tag_colors->[ $tag_num ],
        };
        $tag_num++;
    }

    my %out_files_map = (
        'as_png' => 'png',
        'as_cmapx' => 'cmap',
        'as_svg' => 'svg',
    );
    if ( 1 ) {
        foreach my $cluster_num ( 0..$#$all_clusters ) {

            my $cluster = $all_clusters->[ $cluster_num ];
            my $cluster_name = $cluster->{name};

            my $out_files = {};
            foreach my $method_name ( keys %out_files_map ) {
                my $out_file_basename = $cluster->{name};
                my $file_type = $out_files_map{ $method_name };
                my $t_out_dir = $out_dir . '/' . 'cluster-' . $file_type;
                unless ( -d $t_out_dir ) {
                    mkdir( $t_out_dir ) or die "Can't create directory '$t_out_dir': $!\n";
                }
                my $out_file = $t_out_dir . '/' . $out_file_basename .  '.' . $file_type;
                $out_files->{$method_name} = $out_file;
            }

            print "Running for tag '$cluster->{name}'.\n" if $ver >= 3;
            my $translator = SQL::Translator->new(
                filename  => $input_file,
                parser => 'MySQL',
                producer => 'TTGraphViz',
                debug => ( $ver >= 6 ),

                producer_args => {
                    out_files => $out_files,
                    name => $cluster_name,

                    #layout => 'neato',
                    layout => 'dot',
                    add_color => 0,
                    show_constraints => 1,

                    #width => 22,
                    #height => 18,
                    fontsize => 18,

                    all_clusters => $all_clusters,
                    only_clusters => $cluster->{name},
                    filter_no_cluster_fields_out => 1,
                    filter_in_related_tables => 1,
                    filter_no_cluster_fields_in => 1,

                    table_name_url_prefix => $table_name_url_prefix,
                },

            ) or die SQL::Translator->error;
            $translator->translate;
            #exit;
        }
    }

    my $out_files = {};
    foreach my $method_name ( keys %out_files_map ) {
        my $file_type = $out_files_map{$method_name};
        my $out_file = $out_dir . '/' . 'schema' .  '.' . $file_type;
        $out_files->{$method_name} = $out_file;
    }

    print "Running for full schema.\n" if $ver >= 3;
    my $translator = SQL::Translator->new(
        filename  => $input_file,
        parser => 'MySQL',
        producer => 'TTGraphViz',
        debug => ( $ver >= 6 ),
        producer_args => {
            out_files => $out_files,
            name => 'schema',

            layout => 'dot',
            #layout => 'neato',
            add_color => 0,
            show_constraints => 1,

            width => 30,
            height => 20,
            fontsize => 18,

            node => {
                shape => 'record',
                style => 'filled',
                fillcolor => 'blanchedalmond',
                color => 'red',
            },

            all_clusters => $all_clusters,
            table_name_url_prefix => $table_name_url_prefix,
        },
    ) or die SQL::Translator->error;
    $translator->translate;

    return 1;
}

1;