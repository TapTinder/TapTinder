package TapTinder::Web::Controller::API1::Project::Rep;

# ABSTRACT: TapTinder::Web API project/*/rep controller.

use Moose;
use namespace::autoclean;

BEGIN { extends
	'TapTinder::Web::Controller::API1::Project',
	'TapTinder::Web::Data::Rep'
}

use strict;
use warnings;


sub rep_base : Chained('project_stash') PathPart('rep') CaptureArgs(0) {}

sub rep_index : Chained('rep_base') PathPart('') Args(0) ActionClass('REST') {}

=method rep_index_GET

Return rep_data.

=cut

sub rep_index_GET : Private {
	my ( $self, $c ) = @_;
	$self->status_ok(
		$c,
		entity => {
			reps => $self->rep_data(
				$c->model('WebDB')->schema,
				$c->stash->{project_id}
			),
		},
	);
}

=method rep_index_PUT

Add repository (rep table) to project.

=cut

sub rep_index_PUT : Private {
	my ( $self, $c ) = @_;
	return $self->PUT2table_row( $c,
		'rep',
		{ project_id => $c->stash->{project_id} }
	);
}

sub rep_stash : Chained('rep_base') PathPart('') CaptureArgs(1) {
	my ( $self, $c, $rep_id ) = @_;
	$c->stash->{rep_id} = $rep_id;
}

sub rep_id : Chained('rep_stash') PathPart('') Args(0) ActionClass('REST') {}

=method rep_id_GET

Return rep_data of one id.

=cut

sub rep_id_GET : Private {
	my ( $self, $c ) = @_;
	$self->status_ok( $c,
		entity => {
			rep => $self->rep_data(
				$c->model('WebDB')->schema,
				$c->stash->{project_id},
				$c->stash->{rep_id}
			),
		},
	);
}

=method rep_id_DELETE

Remove rep.

=cut

sub rep_id_DELETE : Private {
	my ( $self, $c ) = @_;

	return $self->DELETE_table_rows( $c,
		'rep',
		{
			project_id => $c->stash->{project_id},
			rep_id => $c->stash->{rep_id}
		}
	);
}

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut

__PACKAGE__->meta->make_immutable;

1;
