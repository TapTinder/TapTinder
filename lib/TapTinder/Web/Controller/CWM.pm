package TapTinder::Web::Controller::CWM;

# ABSTRACT: TapTinder::Web cwm (See Web Magic) controller.

use strict;
use warnings;
use base 'CatalystX::Controller::CWebMagic';

=head1 DESCRIPTION

Catalyst Controller to see web magic on TapTinder.

=cut

sub db_schema_base_class_name {
  return 'WebDB';
}


sub db_schema_class_name {
  return 'TapTinder::Web::Model::WebDB';
}


sub get_prepare_conf {
    my ( $self, $c ) = @_;
    return {};
}


=method index

Base index method.

=cut

sub index : Path {
    my $self = shift;
    return $self->base_index( @_ );
}


=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
