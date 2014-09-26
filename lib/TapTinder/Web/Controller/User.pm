package TapTinder::Web::Controller::User;

# ABSTRACT: TapTinder::Web report controller.

use base 'TapTinder::Web::ControllerBase';
use strict;
use warnings;

=head1 DESCRIPTION

Catalyst controller for TapTinder web user.

=cut

sub index : Path Args(0) {
    my ( $self, $c ) = @_;

    unless ( $c->user_exists() ) {
        $c->response->redirect( $c->uri_for($c->controller('User')->action_for('login')) );
        $c->detach();
        return;
    }

    $c->go('home');
}


sub home : Private {
    my ( $self, $c ) = @_;

    $c->stash->{login} = $c->user->get('login');
    $c->stash->{user} = $c->user->obj;
    $c->stash->{is_admin} = 0;
    if ( $c->check_user_roles('admin') ) {
        $c->stash->{is_admin} = 1;
    }
}


sub login : Local Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'template'} = 'user/login.tt2';

    # Already signed in.
    if ( $c->user_exists() ) {
        $c->response->redirect( $c->uri_for($c->controller('User')->action_for('home')) );
        return;
    }

    # Process login/password from login form.
    if ( exists($c->req->params->{'login'}) ) {

        if ($c->authenticate({
			login => $c->req->params->{'login'},
			passwd => $c->req->params->{'password'},
			active => 1,
		  }) )
        {
            ## user is signed in.
            $c->stash->{'message'} = "You are now logged in.";
            $c->response->redirect( $c->uri_for($c->controller('User')->action_for('index')) );
            $c->detach();
            return;
        }

        $c->stash->{'error'} = "Invalid login or password.";
    }

    # display the login form
}



sub logout : Local Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'template'} = 'user/logout.tt2';

    if ( $c->user_exists() ) {
        $c->logout();
        $c->stash->{'notice'} = "You have been logged out.";
    } else {
        $c->stash->{'notice'} = "You were not logged in.";
    }
}


=head1 SEE ALSO

L<TapTinder::Web>, L<Catalyst::Controller>

=cut


1;
