package TapTinder::Web::Controller::API1::WConfJob;

# ABSTRACT: TapTinder::Web API wconfjob controller.

use base qw/
	TapTinder::Web::ControllerAPI1
	TapTinder::Web::Data::Job
/;

use strict;
use warnings;

sub wconfjob :Path :Args(0) :ActionClass('REST') {}


=method wconfjob_GET

Return wconfjob_data.

=cut

sub wconfjob_GET : Private {
    my ( $self, $c ) = @_;
    $self->status_ok(
        $c,
        entity => $self->wconfjob_data( $c->model('WebDB')->schema ),
    );
}

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut

__PACKAGE__->meta->make_immutable;

1;
