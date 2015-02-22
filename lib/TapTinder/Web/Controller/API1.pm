package TapTinder::Web::Controller::API1;

# ABSTRACT: TapTinder::Web API1 base controller.

use base 'TapTinder::Web::ControllerAPI1';

use strict;
use warnings;

sub index :Path :Args(0) :ActionClass('REST') {}

=method index

Base index method.

=cut


sub index_GET : Private {
    my ( $self, $c ) = @_;

	my $data = {
		check => {
			uri => $c->uri_for('check') . "",
			info => 'TapTinder environment checks.',
		},
		wconfjob => {
			uri => $c->uri_for('wconfjob') . "",
			info => 'Jobs - clients mapping.',
		}
	};

	$self->status_ok(
		$c,
		entity => $data,
	);
}


=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
