package TapTinder::Web::ControllerAPI1;

# ABSTRACT: TapTinder::Web base class for controllers.

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller::REST' }

use YAML::Syck;
use URI::Find;
use Data::Dumper;


__PACKAGE__->config(
    'default'   => 'application/json',
    'stash_key' => 'rest',
    'map'       => {
        'application/json' => 'JSON::XS',
        # YAML serialize is YAML::Syck in real
        'text/x-yaml'      => 'YAML',
        'text/html'        => [ 'View', 'TT', ],

        # todo - proper way to not support other contenty-types than above?
        'text/xml'           => undef,
        'text/x-json'        => undef,
        'text/x-data-dumper' => undef,
        'text/x-data-denter' => undef,
        'text/x-data-taxi'   => undef,
        'application/x-storable'   => undef,
        'application/x-freezethaw' => undef,
        'text/x-config-general'    => undef,
        'text/x-php-serialization' => undef,
    }
);


sub html_dumper {
    my ( $data ) = @_;

    my $html = Dump( $data );

    my $finder = URI::Find->new( sub {
        my ( $uri, $orig_uri ) = @_;
        return qq|<a href="$orig_uri">$orig_uri</a>|;
    } );
    $finder->find( \$html );
    return $html;
}


sub auto : Private {
    my ( $self, $c ) = @_;

    # ToDo - only for text/html (TT)
    #if ( $c->response->content_type eq 'text/html' ) {
        $c->stash->{rest_html_dump} = \&html_dumper;
        $c->stash->{template} = 'api1/default.tt2';
    #}
    return 1;
}


1;
