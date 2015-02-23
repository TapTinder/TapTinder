package TapTinder::Web::Data::Base;

# ABSTRACT: TapTinder::Web base class for data classes.

use strict;
use warnings;

=method rs2data_by_id

Return hash with id as key and hash with data as key.

=cut

sub rs2data_by_id {
	my ( $self, $rs ) = @_;
	my %data;
	while ( my $row = $rs->next ) {
		my %rc = $row->get_columns();
		$data{ $rc{id} } = \%rc;
	}
	return \%data;
}

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut

1;
