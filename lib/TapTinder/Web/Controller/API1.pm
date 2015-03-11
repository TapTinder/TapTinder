package TapTinder::Web::Controller::API1;

# ABSTRACT: TapTinder::Web API1 base controller.

use strict;
use warnings;

use Moose;
use namespace::autoclean;
BEGIN { extends 'TapTinder::Web::ControllerAPI1' }

sub api1_base : Chained('/') PathPart('api1') CaptureArgs(0) {}

sub api1_index : Chained('api1_base') PathPart('') Args(0) ActionClass('REST') {}

=method index

Base index method.

=cut

sub api1_index_GET : Private {
    my ( $self, $c ) = @_;

	my $data = {
		check => {
			uri => $c->uri_for('check') . "",
			info => 'TapTinder environment checks.',
		},
		project => {
			uri => $c->uri_for('project') . "",
			info => 'Projects.',
		},
		wconfjob => {
			uri => $c->uri_for('wconfjob') . "",
			info => 'Jobs - clients mapping.',
		},
	};

	$c->stash->{template} = 'api1/index.tt2';
	$self->status_ok(
		$c,
		entity => $data,
	);
}

__PACKAGE__->meta->make_immutable;

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
