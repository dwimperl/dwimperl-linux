use strict;
use warnings;

use Test::More;
plan tests => 2;

is $], '5.020001', 'perl version';

use HTML::Template;
use Mojolicious;

ok 1;



