package TapTinder::Web::View::TT;

# ABSTRACT:  TapTinder TT (TemplateToolkit) site view.

use base 'Catalyst::View::TT';
use strict;

=head1 SYNOPSIS

See L<TapTinder::Web>

=head1 DESCRIPTION

TapTinder TT Site View.

=cut

__PACKAGE__->config({
    CATALYST_VAR => 'c',
    INCLUDE_PATH => [
        TapTinder::Web->path_to( 'root', 'src' ),
        TapTinder::Web->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TIMER        => 0,
    TEMPLATE_EXTENSION => '.tt2',
    #COMPILE_DIR => '/tmp/taptinder/cache',
    render_die => 0,
});


1;
