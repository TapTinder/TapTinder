package TapTinder::Worker;

# ABSTRACT: TapTinder::Worker is base class for all workers.

use strict;
use warnings;

use Carp qw(carp croak verbose);
use Data::Dumper;
use File::Spec;


=head1 DESCRIPTION

Base of worker to update repository data.

=head2 new

Constructor.

=cut

sub new {
    my ( $class, %args ) = @_;

    my $self = {
        vl => $args{verbose_level},
    };
    bless( $self, $class );
    return $self;
}


sub dmp {
    my $self = shift;
    my $dd = Data::Dumper->new( [ @_ ] );
    $dd->Indent(1);
    $dd->Terse(1);
    $dd->Purity(1);
    $dd->Deepcopy(1);
    $dd->Deparse(1);
    return $dd->Dump;
}

sub save_state {
    my ( $self, $state, $state_fn ) = @_;
    open SFH, ">", $state_fn or croak "Can't open '$state_fn' for writing: $!";
    print SFH $self->dmp($state)."\n";
    close SFH || croak "Can't finish writing to '$state_fn': $!";
}

=head1 SEE ALSO

L<TapTinder::Worker>

=cut

1;