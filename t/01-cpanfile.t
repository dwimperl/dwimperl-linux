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
		next if $module eq 'local::lib';      # it seems to cause problems when loading (Attempting to create directory /home/dwimperl/perl5)
		next if $module eq 'perlfaq';         # Don't be silly, you can't load perlfaq
		next if $module eq 'Log::Contextual'; # error: (Log::Contextual does not have a default import list)
		next if $module eq 'threads';         # error: (Attempt to reload threads.pm aborted.)
		#diag "$module  - $version";
		use_ok $module;
	} else {
		diag "Invalid line $line";
	}

}

done_testing;
