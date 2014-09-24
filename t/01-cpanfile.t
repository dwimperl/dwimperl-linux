use strict;
use warnings;

use Test::More;

is $], '5.020001', 'perl version';

#requires 'autodie',                    '2.25';
#requires 'Acme::MetaSyntactic';
open my $fh, '<', 'cpanfile' or die;
while (my $line  = <$fh>) {
	chomp $line;
	next if $line =~ /^#/;
	next if $line =~ /^\s*$/;
	if ($line =~ /^requires\s+'([^']+)'(?:,\s*'([^']+)')?;/) {
		my $module = $1;
		my $version = $2 // 0;
		#diag "$module  - $version";
		use_ok $module;
	} else {
		diag "Invalid line $line";
	}

}

done_testing;
