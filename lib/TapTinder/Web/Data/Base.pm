package TapTinder::Web::Data::Base;

# ABSTRACT: TapTinder::Web base class for data classes.

use strict;
use warnings;

=method rs2data_by_ids

Return hashref with id as key and hash with data as key.

=cut

sub rs2data_by_ids {
	my ( $self, $rs ) = @_;
	my %data;
	while ( my $row = $rs->next ) {
		my %rc = $row->get_columns();
		$data{ $rc{id} } = \%rc;
	}
	return \%data;
}

=method rs2data_by_id

Return hashref with data loaded from the first row of resultSet.

=cut

sub rs2data_by_id {
	my ( $self, $rs ) = @_;
	my %data;
	my $row = $rs->next;
	my %rc = $row->get_columns();
	return \%rc;
}

=method create_new_table_row

Create new row in table from provided data.

=cut

sub create_new_table_row {
    my ( $self, $schema, $table_name, $rh_new_vals ) = @_;

    my $rs = $schema->resultset($table_name)->create($rh_new_vals);
    return undef unless $rs;
    my $new_id = $rs->get_column($table_name.'_id');
    return $new_id, { $rs->get_columns() };
}

=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut

1;
