package TapTinder::Web::Controller::API1::Project;

# ABSTRACT: TapTinder::Web API wconfjob controller.

use base qw/
	TapTinder::Web::ControllerAPI1
	TapTinder::Web::Data::Project
/;

use strict;
use warnings;

sub project :Path :Args(0) :ActionClass('REST') {}


=method project_GET

Return project_data.

=cut

sub project_GET : Private {
	my ( $self, $c ) = @_;
	$self->status_ok(
		$c,
		entity => {
			projects => $self->projects_data( $c->model('WebDB')->schema ),
		},
	);
}

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut

__PACKAGE__->meta->make_immutable;

1;
