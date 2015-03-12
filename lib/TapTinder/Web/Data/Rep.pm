package TapTinder::Web::Data::Rep;

# ABSTRACT: TapTinder::Web data for project's reps.

use strict;
use warnings;
use base 'TapTinder::Web::Data::Base';

=method projects_data

Return proejects data.

=cut

sub rep_data {
	my ( $self, $schema, $project_id, $id, $search ) = @_;

	$search = {
		active => 1,
	} unless defined $search;
	$search->{project_id} = $project_id if $project_id;
	$search->{rep_id} = $id if $id;

	my $rs = $schema->resultset('rep')->search(
		$search,
		{
			select => [qw/ me.rep_id  me.project_id  me.name  me.repo_url  me.github_url me.descr /],
			as     => [qw/ id         project_id     name     repo_url     github_url    descr    /],
		},
	);
	return $self->rs2data_by_id( $rs ) if $id;
	return $self->rs2data_by_ids( $rs );
}

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut

1;
