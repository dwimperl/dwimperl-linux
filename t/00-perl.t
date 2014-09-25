use strict;
use warnings;

use Test::More;
use Config;
use Cwd qw(getcwd);

plan tests => 1;

diag "\$Config{perlpath}=$Config{perlpath}";
diag "\$^X=$^X";
diag "\$0=$0";
diag 'getcwd=' . getcwd();
diag qx{$Config{perlpath} -V};

is $], '5.020001', 'perl version';


