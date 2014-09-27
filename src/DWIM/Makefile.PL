use strict;
use warnings;
use ExtUtils::MakeMaker;

my %conf = (
	NAME          => 'DWIM',
	VERSION_FROM  => 'lib/DWIM.pm',
	ABSTRACT_FROM => 'lib/DWIM.pm',
	PREREQ_PM     => {
	},
);

if (eval { ExtUtils::MakeMaker->VERSION(6.3002) }) {
	$conf{LICENSE} = 'perl';
}

if (eval { ExtUtils::MakeMaker->VERSION(6.46) }) {
	$conf{META_MERGE} = {
		'meta-spec' => { version => 2 },
		resources => {
			repository => {
				type => 'git',
				url  => 'http://github.com/dwimperl/dwimperl-linux.git',
				web  => 'http://github.com/dwimperl/dwimperl-linux',
			}
		}
	};
}

my %configure_requires = (
        'ExtUtils::MakeMaker' => '6.64',
);
my %build_requires = ();
my %test_requires = (
);

###   merging data "standard code"
if (eval { ExtUtils::MakeMaker->VERSION(6.52) }) {
	$conf{CONFIGURE_REQUIRES} = \%configure_requires;
} else {
	%{ $conf{PREREQ_PM} } = (%{ $conf{PREREQ_PM} }, %configure_requires);
}

if (eval { ExtUtils::MakeMaker->VERSION(6.5503) }) {
	$conf{BUILD_REQUIRES} = \%build_requires;
} else {
	%{ $conf{PREREQ_PM} } = (%{ $conf{PREREQ_PM} }, %build_requires);
}
if (eval { ExtUtils::MakeMaker->VERSION(6.64) }) {
	$conf{TEST_REQUIRES} = \%test_requires;
} else {
	%{ $conf{PREREQ_PM} } = (%{ $conf{PREREQ_PM} }, %test_requires);
}
WriteMakefile(%conf);

