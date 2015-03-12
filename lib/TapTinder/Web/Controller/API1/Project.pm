package TapTinder::Web::Controller::API1::Project;

# ABSTRACT: TapTinder::Web API project controller.

use Moose;
use namespace::autoclean;

BEGIN { extends
	'TapTinder::Web::ControllerAPI1',
	'TapTinder::Web::Data::Project'
}

use strict;
use warnings;


sub project_base : Chained('/') PathPart('api1/project') CaptureArgs(0) {}

sub project_index : Chained('project_base') PathPart('') Args(0) ActionClass('REST') {}

=method project_index_GET

Return project_data.

=cut

sub project_index_GET : Private {
	my ( $self, $c ) = @_;
	$self->status_ok(
		$c,
		entity => {
			projects => $self->project_data(
				$c->model('WebDB')->schema
			),
		},
	);
}

=method project_index_PUT

Add project.

=cut

sub project_index_PUT : Private {
	my ( $self, $c ) = @_;
	return $self->PUT2table_row( $c, 'project' );
}

sub project_stash : Chained('project_base') PathPart('') CaptureArgs(1) {
	my ( $self, $c, $project_id ) = @_;
	$c->stash->{project_id} = $project_id;
}

sub project_id : Chained('project_stash') PathPart('') Args(0) ActionClass('REST') {}

=method project_id_GET

Return projects_data of one id.

=cut

sub project_id_GET : Private {
	my ( $self, $c ) = @_;
	$self->status_ok( $c,
		entity => {
			project => $self->project_data(
				$c->model('WebDB')->schema,
				$c->stash->{project_id}
			),
		},
	);
}

=method project_id_DELETE

Remove project.

=cut

sub project_id_DELETE : Private {
	my ( $self, $c ) = @_;

	return $self->DELETE_table_rows( $c,
		'project',
		{ project_id => $c->stash->{project_id} }
	);
}

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut

__PACKAGE__->meta->make_immutable;

1;
