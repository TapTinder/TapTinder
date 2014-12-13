#!/usr/bin/env perl

use strict;
use warnings;
use Carp qw(carp croak verbose);
use FindBin qw($RealBin);

use Getopt::Long;
use Pod::Usage;

use Data::Dumper;
use File::Spec::Functions;

use Bot::BasicBot::Pluggable;

use lib "$FindBin::Bin/../lib";
use TapTinder::DB;
use TapTinder::Utils::Conf qw(load_conf_multi);
use TapTinder::Utils::DB qw(get_connected_schema);


my $help = 0;
my $ver = 2;
my $debug = undef;
my $db_type = 'prod';
my $ibot_id = undef;
my $options_ok = GetOptions(
    'help|h|?' => \$help,
    'ibot_id=i' => \$ibot_id,
    'db_type=s' => \$db_type,
    'ver|v=i' => \$ver,
    '+debug' => \$debug,
);
pod2usage(1) if $help || !$options_ok;
unless ( defined $ibot_id ) {
    print "No ibot_id given.\n";
    pod2usage(1);
}

my $conf_dir = $ENV{'TAPTINDER_SERVER_CONF_DIR'} || catdir( $RealBin, '..', 'conf');
my $conf = load_conf_multi( $conf_dir, 'db' );

my $schema = get_connected_schema( $conf->{db} );

my $ibot_row = $schema->resultset('ibot')->find(
    $ibot_id,
    {
        join => 'operator_id',
        '+select' => 'operator_id.irc_nick',
        '+as' => 'operator_irc_nick',
    }
);
croak "Bot with id = $ibot_id not found." unless $ibot_row;
my %ibot = $ibot_row->get_columns;

# ToDo - use distinct
my $ichannel_rs = $schema->resultset('ichannel_conf')->search(
    { 'me.ibot_id' => $ibot_id, },
    {
        join     => [ qw/ ichannel_id / ],
        'select' => [ qw/ ichannel_id.name / ],
        'as'     => [ qw/ channel_name / ],
    }
);
croak "Channel conf for bot_id = $ibot_id not found." unless $ichannel_rs;
my $channel_names = {};
while ( my $ichannel_row = $ichannel_rs->next ) {
    my %ichannel = $ichannel_row->get_columns;
    my $channel_name = $ichannel{channel_name};
    $channel_names->{ $channel_name } = 1;
}


# Pass any option that's valid for Bot::BasicBot.
my $bot = Bot::BasicBot::Pluggable->new(
    nick     => $ibot{nick},
    altnicks => [],
    name     => $ibot{full_name},
    server   => $ibot{server},
    port     => $ibot{port},
    username => $ibot{operator_irc_nick},
    channels => [ keys %{ $channel_names } ],
);

$bot->load("Auth");
$bot->load("TapTinderBot");

my $server_base_url = 'http://tt.taptinder.org/';
$server_base_url = 'http://ttdev.taptinder.org/' if $db_type eq 'dev';
$server_base_url = 'http://localhost:2000/' if $db_type eq 'local';

my $TapTinderBot_handler = $bot->handler("TapTinderBot");
$TapTinderBot_handler->_my_init(
    $ibot_id, $schema, $server_base_url, $ver, $debug
);

# This is how you can debug some TapTinderBot methods.
if ( $debug ) {
    $TapTinderBot_handler->_check_news( 1 );

} else {
    $bot->run();
}

__END__

=head1 NAME

ttbot - Start TapTinder bot.

=head1 SYNOPSIS

perl ttbot.pl [options]

Example:
    perl ttbot.pl --server irc.freenode.org --channel TapTinderBot-test

 Options:
   --help
   --db_type .. Possibilities: 'prod', 'dev', 'local'.
   --ibot_id .. ID to ibot table.
   --ver .. Verbosity level.
   --debug .. Debug.

=head1 DESCRIPTION

B<This program> will start ...

=cut
