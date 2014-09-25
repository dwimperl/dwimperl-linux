use strict;
use warnings;

use Test::More;
use Config;
use Cwd qw(getcwd);

plan tests => 1;

                                              # Travis-CI
diag "\$Config{perlpath}=$Config{perlpath}";  # /home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl/bin/perl
diag "\$^X=$^X";                              # /home/travis/dwimperl-linux-5.20.1-4-x86_64/perl/bin/perl
diag "\$0=$0";                                # t/00-perl.t
diag 'getcwd=' . getcwd();                    # /home/travis/build/dwimperl/dwimperl-linux
#diag qx{$Config{perlpath} -V};                # Can't exec "/home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl/bin/perl": No such file or directory
diag explain \%Config;

is $], '5.020001', 'perl version';


