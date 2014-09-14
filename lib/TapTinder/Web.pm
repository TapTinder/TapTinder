package TapTinder::Web;
use Moose;
use namespace::autoclean;

# ABSTRACT: Web user interface for TapTinder Server.

use strict;
use warnings;
use Data::Dumper;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    StackTrace

    Config::Multi
    Static::Simple

    Authentication
    Authorization::Roles
    Session
    Session::Store::FastMmap
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.60';

# Note that settings in web_*.yml take precedence over this.
# Thus configuration details given here can function as a default
# configuration, with a external configuration file acting
# as an override for local deployment.

TapTinder::Web->config(
    # Disable deprecated behavior needed by old applications
    #disable_component_resolution_regex_fallback => 1,
    'namespace' => '',
    'default_view' => 'TT',
    'Plugin::Config::Multi' => {
        dir => TapTinder::Web->path_to('./conf'),
        prefix => '',
        app_name => 'web',
        extension => 'yml',
    },
    'Plugin::Static::Simple' => {
        #logging => 1,
        #debug => 1,
        mime_types => {
            t => 'text/plain', # Show test files, as text plain. BY mime type it si 'application/x-troff'.
        },
    },
    'root' => TapTinder::Web->path_to('root'),

    'Plugin::Authentication' => {
        default => {
            credential => {
                class => 'Password',
                password_type => 'crypted',
                password_field => 'passwd'
            },
            store => {
                class => 'DBIx::Class',
                user_model => 'WebDB::User',
                role_relation => 'roles',
                role_field => 'role',
                use_userdata_from_session => '1',
            }
        }
    }

);


TapTinder::Web->setup;

=head1 DESCRIPTION

TapTinder Web server base class based on Catalyst::Runtime.

=head1 SEE ALSO

L<TapTinder>, L<Catalyst::Runtime>

=cut


1;
