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

has config_file => (is => 'rw');
has url         => (is => 'rw');

main->new_with_options->run;
exit;

sub run {
	my ($self) = @_;

	$self->config_file(File::HomeDir->my_home . '/.digitalocean');
	$self->url('https://github.com/dwimperl/dwimperl-linux/archive/experiment-0.01.zip');
	(my $zip_file = $self->url) =~ s{.*/}{};
	my $dir = 'dwimperl-linux-' . substr($zip_file, 0, -4);

	$self->usage('Missing config') if !-e $self->config_file;

	say $zip_file if $self->verbose;
	say $dir if $self->verbose;
	
	my $Config = Config::Tiny->read( $self->config_file, 'utf8' );

	my $ssh_key_id = delete $Config->{one}{ssh_key_id};
	my $do = DigitalOcean->new(%{ $Config->{one} });

	if ($self->list) {
		for my $droplet (@{$do->droplets}) {
			printf "Droplet %s has id %s and IP address %s\n", $droplet->name, $droplet->id, $droplet->ip_address;
		}
		return;
	}

	die "Exactly on of --create and   --droplet ID\n" if not $self->create xor $self->droplet;
	
	if ($self->create) {
		say 'Creating droplet. Takes about 60 secons. Please wait';
		my $t0 = time;
		my $droplet = $do->create_droplet(
		    name           => 'dwimperl',
		    size_id        =>  66,        # 512Mb
		    image_id       => '1601',     # CentOS 5.8 x64 
		    ssh_key_ids    => $ssh_key_id,
		    region_id      => 8,          # New York 3
		    wait_on_event  => 1,
		);
		my $t1 = time;
		say 'Elapsed time creating the Droplet: ' . $t1-$t0;
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
		'wget ' . $self->url,
		"unzip $zip_file",
		"cd $dir",

		# build 'vanilla perl with cpanm'
		"./build.sh perl",
		"./build.sh cpanm",
		"./build.sh test_perl",
		"./build.sh zip",

		# based on 'vanilla perl' add all the modules
		#"./build.sh get_vanilla_perl",
		#"./build.sh modules",
		#"./build.sh test_all",
		#"./build.sh zip",
	);
	$self->ssh($username, $server->ip_address, \@user_cmds);

	# download the zip file
	#my $cmd = sprintf 'scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no %s@%s:%s %s',  $username, $ip_address, $remote_filename, $local_filename;
	#say $cmd if $self->verbose; 
	#system $cmd;

	if ($self->create) {
		say 'Destroying the server';
		$server->destroy;
	}
}

sub ssh {
	my ($self, $username, $ip_address, $cmds) = @_;

	foreach my $cmd (@$cmds) { 
		my $full_cmd = sprintf 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no %s@%s "%s"',  $username, $ip_address, $cmd;
		say $full_cmd if $self->verbose; 
		system $full_cmd;
	}
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

