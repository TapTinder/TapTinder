use strict;
use warnings;

use lib 'lib';
use TapTinder::Web;

my $app = TapTinder::Web->apply_default_middlewares(TapTinder::Web->psgi_app);
$app;
