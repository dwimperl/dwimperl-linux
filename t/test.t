use strict;
use warnings;

use Test::More;
plan tests => 2;

is $], '5.020001', 'perl version';

use Acme::MetaSyntactic;
use App::cpanminus;
use Business::PayPal;
use CGI::Deurl::XS; # recommended module
use Code::Explain;
use Crypt::URandom; # recommended module
use Dancer;
use Dancer2;
use DateTime;
use DBD::SQLite;
use DBI;
use ExtUtils::MakeMaker;
use HTML::Template;
use local::lib;
use Log::Log4perl;
use LWP::Protocol::PSGI;
use Math::Random::ISAAC::XS; # recommended module
use Mojolicious;
use Parse::CPAN::Meta;  # forcing minimum version needed for both Dancer and Dancer2
use Test::Memory::Cycle;
use Test::MockTime;
use Test::Output;
use Test::Script;
use Scope::Upper; # recommended module
use URL::Encode::XS; # recommended module


ok 1;



