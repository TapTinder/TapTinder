package TapTinder::Web::Controller::API1::Check;

# ABSTRACT: TapTinder::Web API installation check controller.

use base 'TapTinder::Web::ControllerAPI1';

use strict;
use warnings;

use Data::Dumper;
use File::Spec;
use File::Temp;

use TapTinder::Web::Check::DB;
use TapTinder::Web::Check::Path;


sub check :Path :Args(0) :ActionClass('REST') {}


=method check_GET

Base method.

=cut

sub check_GET : Private {
    my ( $self, $c ) = @_;

    my $data = {};
    $data->{uploadtmp} = TapTinder::Web::Check::Path::uploadtmp_exists(
        $c->config->{uploadtmp}
    );

    $data->{db} = TapTinder::Web::Check::DB::connected(
        $c->config->{db},
        $c->model('WebDB::param_type')
    );

    $self->status_ok(
        $c,
        entity => {
            checks => $data,
        },
    );
}

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
