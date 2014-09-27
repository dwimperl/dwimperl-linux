package DWIM;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

DWIM - Do What I Mean adjust the path in %Config when perl is relocated

=head1 SYNOPSIS

    export PERL5OPT="-MDWIM"

Then every scipt will automatically load this module and adjust the variable of C<%Config> to point to the real path.

   perl -MDWIM script.pl

Will do the same but for this specific execution of script.pl

adding

    use DWIM;

to the beginning of script.pl will make the adjustment for every run script.pl


=cut

# Based on code from Portable::Config


# $ perl -MConfig -MData::Dumper -E'print Dumper \%Config' | grep '/home/dwimp'

#  'config_arg3' => '-Dprefix=/home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl',
#  'config_args' => '-des -Duserelocatableinc -Dprefix=/home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl',
#  'initialinstalllocation' => '/home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl/bin',
#  'installbin' => '/home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl/bin',
#  'installprefix' => '/home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl',
#  'perlpath' => '/home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl/bin/perl',
#  'startperl' => '#!/home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl/bin/perl',


apply();


sub apply {
    # Force all Config entries to load, so that
    # all Config_heavy.pl code has run, and none
    # of our values will be overwritten later.
    require Config;
    my $preload = { %Config::Config };

    # Shift the tie STORE method out the way
    SCOPE: {
        no warnings;
        *Config::_TEMP = *Config::STORE;
        *Config::STORE = sub {
            $_[0]->{$_[1]} = $_[2];
        };
    }

    # remove /bin/perl from the end
    my $old = substr $Config::Config{perlpath}, 0, -9;
    my $new = substr $^X, 0, -9;
    #print "old='$old'\n";
    #print "new='$new'\n";

    # Write the values to the Config hash
    foreach my $key ( sort keys %Config::Config ) {
        next if not defined $Config::Config{$key};
        $Config::Config{$key} =~ s{$old}{$new};
    }

    # Restore the STORE method
    SCOPE: {
        no warnings;
        *Config::STORE = delete $Config::{_TEMP};
    }

    return 1;
}


1;

