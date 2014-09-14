#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use lib 'lib';
use Catalyst::Test 'TapTinder::Web';

ok( request('/')->is_success, 'Request should succeed' );

done_testing();
