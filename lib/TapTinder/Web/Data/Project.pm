package TapTinder::Web::Data::Project;

# ABSTRACT: TapTinder::Web data for projects.

use strict;
use warnings;
use base 'TapTinder::Web::Data::Base';

=method projects_data

Return proejects data.

=cut

sub projects_data {
	my ( $self, $schema ) = @_;

	my $rs = $schema->resultset('project')->search(
		undef,
		{
			select => [qw/ me.project_id  me.name  me.url  me.descr /],
			as     => [qw/ id             name     url     descr    /],
		},
	);
	return $self->rs2data_by_id( $rs );
}

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut

1;
