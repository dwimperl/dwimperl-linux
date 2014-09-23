#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Config::Tiny;
use Data::Dumper qw(Dumper);
use DigitalOcean;
use File::HomeDir;


my $config_file = File::HomeDir->my_home . '/.digitalocean';
my $url = 'https://github.com/dwimperl/dwimperl-linux/archive/experiment-0.01.zip';
(my $zip_file = $url) =~ s{.*/}{};
my $dir = 'dwimperl-linux-' . substr($zip_file, 0, -4);
say $zip_file;
say $dir;
exit;

main();
exit;

sub main {
	usage('Missing config') if !-e $config_file;
	
	my $Config = Config::Tiny->read( $config_file, 'utf8' );

	my $ssh_key_id = delete $Config->{one}{ssh_key_id};
	my $do = DigitalOcean->new(%{ $Config->{one} });
	
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

	my $server = $do->droplet($droplet->id);
	printf "ID: %s  name %s IP: %s\n", $server->id, $server->name, $server->ip_address;

	my $cmd = sprintf 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@%s "uname -a; uptime; hostname"',  $server->ip_address;
	say $cmd;
	system $cmd;

	say 'Destroying the server';
	$server->destroy;
}

sub usage {
	my ($msg) = @_;
	say $msg if $msg;

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

