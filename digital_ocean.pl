#!/usr/bin/perl
use 5.010;
use Moo;
use MooX::Options;

use Config::Tiny;
use Data::Dumper qw(Dumper);
use DigitalOcean;
use File::HomeDir;

option list     => (is => 'ro', doc => 'List available droplets');
option verbose  => (is => 'ro');
option droplet  => (is => 'rw', format => 's', doc => 'Droplet ID - Use this Droplet instead of creating new');
option create   => (is => 'ro');
option base     => (is => 'ro', format => 'i', doc => 'Base the build on this subversion (0, 1, 2, ...)');

has config_file => (is => 'rw');
has tag         => (is => 'rw');

main->new_with_options->run;
exit;

sub run {
	my ($self) = @_;

	$self->config_file(File::HomeDir->my_home . '/.digitalocean');
	#$self->tag('experiment-0.01');
	my $url = 'https://github.com/dwimperl/dwimperl-linux/archive';
	$self->tag('master');
	my $zip_file = $self->tag . '.zip';
	my $bare_file = $self->tag;
	my $dir = 'dwimperl-linux-' . $self->tag;

	$self->usage('Missing config') if !-e $self->config_file;

	say "\$zip_file=$zip_file" if $self->verbose;
	say "\$dir=$dir" if $self->verbose;
	
	my $Config = Config::Tiny->read( $self->config_file, 'utf8' );

	my $ssh_key_id = delete $Config->{one}{ssh_key_id};
	my $do = DigitalOcean->new(%{ $Config->{one} });

	if ($self->list) {
        say 'Droplets';
		for my $droplet (@{ $do->droplets }) {
			printf "Droplet %s has id %s and IP address %s\n", $droplet->name, $droplet->id, $droplet->ip_address;
		}
		say '------';
		say 'Images';
		foreach my $img (sort { $a->distribution cmp $b->distribution or $a->name cmp $b->name } @{ $do->images }) {
			printf "%-10s %7s  %-50s - %s\n", $img->distribution, $img->id, $img->name, ($img->slug || '');
		}
		say '------';
		return;
	}

	die "Exactly on of --create,  --droplet ID, --list, --help\n" if not $self->create xor $self->droplet;
	die "--base is required\n" if not defined $self->base;
	
	if ($self->create) {
		printf "Creating droplet. Can take about 60 seconds. Started at %s, Please wait. \n", scalar localtime;
		my $t0 = time;
		my $droplet = $do->create_droplet(
			name           => 'dwimperl',
			size_id        =>  66,        # 512Mb
			#image_id       => '1601',    # CentOS 5.8 x64
			#image_id       => 6344382,    # CentOS 5.10 x64
			image_id       => 6372321,    #CentOS 5.8 x64
			ssh_key_ids    => $ssh_key_id,
			region_id      => 8,          # New York 3
			wait_on_event  => 1,
		);
		my $t1 = time;
		say 'Elapsed time creating the Droplet: ' . ($t1-$t0) . ' seconds';
		$self->droplet( $droplet->id );
	}

	my $server = $do->droplet($self->droplet);
	printf "ID: %s  name %s IP: %s\n", $server->id, $server->name, $server->ip_address;

	my $username = 'dwimperl';
	my @root_cmds = (
		"adduser $username",
		"cp -r .ssh/ /home/$username/",
		'yum -y install make.x86_64',
		'yum -y install gcc.x86_64'
	);
	$self->ssh('root', $server->ip_address, \@root_cmds);

	my @user_cmds = (
		"rm -rf $dir $bare_file $zip_file",  # remove old files (mostly interesting when reusing the same VPS)
		"wget $url/$zip_file",
		# for some reason wget on the old CentOS will download a file called master even when we ask for master.zip
		# that's what we are fixing by renaming bare_file to zip_file
		"[ -e $bare_file ] && mv $bare_file $zip_file",
		"unzip $zip_file",
	);


	my $pref = "DWIM_BASE_VERSION=" . $self->base;
	if ($self->base) {
		# based on an earlier release
		push @user_cmds, (
			"cd $dir; $pref ./build.sh get_base_perl",
			#"cd $dir; $pref ./build.sh dwim",
			#"cd $dir; $pref ./build.sh notest",
			"cd $dir; $pref ./build.sh modules",
			"cd $dir; $pref ./build.sh test_cpanfile",
			#"cd $dir; $pref ./build.sh test_all",
			"cd $dir; $pref ./build.sh zip",
		);
	} else {
		# build perl from scratch with cpanm, only installing modules that need special treatment
		push @user_cmds, (
			"cd $dir; $pref ./build.sh perl",
			"cd $dir; $pref ./build.sh cpanm",
			"cd $dir; $pref ./build.sh openssl",
			"cd $dir; $pref ./build.sh libxml2",
			"cd $dir; $pref ./build.sh zlib",
			"cd $dir; $pref ./build.sh expat",
			"cd $dir; $pref ./build.sh xml-libxml",
			"cd $dir; $pref ./build.sh xml-parser",
			"cd $dir; $pref ./build.sh test_perl",
			"cd $dir; $pref ./build.sh zip",
		);
	}
	my $results = $self->ssh($username, $server->ip_address, \@user_cmds);

	my ($remote_filename) = map { substr $_, 19 } grep { /^GENERATED_ZIP_FILE=/ } @{ $results->[-1] };
	chomp $remote_filename;
	say "\$remote_filename='$remote_filename'" if $self->verbose;
	(my $local_filename = $remote_filename) =~ s{^.*/}{};
	say "\$local_filename='$local_filename'" if $self->verbose;

	# download the zip file
	my $cmd = sprintf 'scp -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no %s@%s:%s %s',  $username, $server->ip_address, $remote_filename, $local_filename;
	say $cmd if $self->verbose;
	system $cmd;

	if ($self->create) {
		say 'Destroying the server';
		$server->destroy;
	}
}

sub ssh {
	my ($self, $username, $ip_address, $cmds) = @_;

	my @results;
	foreach my $cmd (@$cmds) {
		say "===================" if $self->verbose;
		my $full_cmd = sprintf 'ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no %s@%s "%s"',  $username, $ip_address, $cmd;
		say "\$full_cmd=$full_cmd" if $self->verbose;
		my @out = qx{$full_cmd};
		say '@out:' if $self->verbose;
		print @out if $self->verbose;
		say '---';
		push @results, \@out;
	}

	return \@results;
}


sub usage {
	my ($self, $msg) = @_;
	say $msg if $msg;

	my $config_file = $self->config_file;
	print <<"END_USAGE";
Usage: $0

In order to access the DigitaOcean API we need the API keys in $config_file.
[one]
client_id   = ...
api_key     = ...
ssh_key_id  = ...

See also http://perlmaven.com/cloud-automation-at-digital-ocean
END_USAGE
	exit 1;
}

