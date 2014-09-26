package TapTinder::Web::Controller::Root;

# ABSTRACT: TapTinder::Web root controller.

use strict;
use warnings;
use base 'TapTinder::Web::ControllerBase';


# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in Web.pm

__PACKAGE__->config( namespace => '' );


=head1 DESCRIPTION

TapTinder root path action.

=method default

=cut

sub homepage :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $schema = $c->model('WebDB')->schema;

    my $projects_rs = $schema->resultset('wui_project')->search( undef, {
        'select' => [qw/ me.project_id me.wui_order project_id.name /],
        'as' =>     [qw/ project_id    wui_order    name            /],
        join => 'project_id',
        order_by => 'me.wui_order',
    });
    $projects_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my @projects = $projects_rs->all;

    my $rref_rs = $schema->resultset('wui_rref')->search({
        'rref_id.active' => 1,
    }, {
        'select' => [qw/ me.wui_order rref_id.rref_id rref_id.name rep_id.project_id  /],
        'as' =>     [qw/ wui_order    rref_id         rref_name    project_id         /],
        'join' => { 'rref_id' => { 'rcommit_id' => 'rep_id' }, },
        'order_by' => [ 'rep_id.project_id', 'me.wui_order' ],
    });
    $rref_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my @rref = $rref_rs->all;

    $c->stash->{projects} = \@projects;
    $c->stash->{rref} = \@rref;
    $self->dumper( $c, $c->stash );

    $c->stash->{template} =  'index.tt2';
}


sub default : Path {
	my ( $self, $context ) = @_;
	$context->response->status(404);
	$context->response->body('404 not found');
}

=method end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}


=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
