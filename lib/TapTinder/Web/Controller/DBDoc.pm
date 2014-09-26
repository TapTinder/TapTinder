package TapTinder::Web::Controller::DBDoc;

# ABSTRACT: TapTinder::Web dbdoc controller.

use base 'TapTinder::Web::ControllerBase';
use strict;
use warnings;

=head1 DESCRIPTION

Catalyst controller for TapTinder. Shows static documentation files.

=method index

Base index method.

=cut

sub index : Path Args(0) {
    my ( $self, $c ) = @_;

    my @items = $c->model('DBDoc')->list( mode => 'both' );

    my $content = '';
    my $prefix = 'root/dbdoc/';
    my $full_path = TapTinder::Web->path_to($prefix);

    my $prev_dir = '';
    foreach my $item ( @items ) {
        my $name = substr( $item, length($prefix) );
        my ( $dir, $fname ) = $name =~ /^(?:(.*)\/)?([^\/]+)$/;
        if ( $dir ne $prev_dir ) {
            $content .= "</ul>\n" if $prev_dir;
            $content .= "<h2>$dir</h2>";
            $content .= "<ul>\n";
            $prev_dir = $dir;
        }
        if ( -f $full_path.'/'.$name ) {
            $content .= '<li><a href="' . $c->uri_for($name) . '">' . $fname . "</a></li>\n";
        }
        #$content .= $full_path.'/'.$name . '<br>';
    }

    $c->stash->{content} = $content;

    return 1;
}


=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
