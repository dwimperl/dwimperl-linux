requires 'autodie',                    '2.25';
requires 'Acme::MetaSyntactic',        '1.012';
requires 'Algorithm::Diff',            '1.1902';
requires 'AnyEvent',                   '7.07';
requires 'AnyEvent::HTTP',             '2.21';
requires 'AnyEvent::Ping',             '0.006';
#requires 'AnyEvent::Ping::TCP',        '1.00'; # has lots of CPANTESTERS fail reports
requires 'App::Ack',                   '2.14';
requires 'App::cpanminus',             '1.7011';
requires 'App::cpanminus::reporter',   '0.11';
requires 'App::cpanoutdated',          '0.28';
requires 'App::Prove',                 '3.33';
requires 'Archive::Any',               '0.0941';
requires 'Archive::Zip',               '1.38';
requires 'Archive::Tar',               '2.02';
requires 'B::Debug',                   '1.21';
requires 'Business::PayPal',           '0.13';
requires 'Cache::Memcached::Fast',     '0.22';
requires 'Capture::Tiny',              '0.25';
#requries 'Catalyst',                   '5.90073';
requires 'Carp::Always',               '0.13';
requires 'Carp::Assert',               '0.21';
requires 'Carp::Assert::More',         '1.14';
requires 'CGI',                        '4.04';
requires 'CGI::Simple',                '1.113';
requires 'CGI::Deurl::XS',             '0.07';
requires 'CGI::Fast',                  '2.03';
requires 'CHI',                        '0.58';
requires 'Class::Adapter',             '1.08';
requires 'Class::Inspector',           '1.28';
requires 'Class::XSAccessor',          '1.19';
requires 'Code::Explain',              '0.02';
requires 'Compress::Zlib',             '2.066';
requires 'Config::Any',                '0.24';
requires 'Config::General',            '2.56';
requires 'Config::Tiny',               '2.20';
requires 'Cpanel::JSON::XS',           '3.0104';
requires 'CPAN::Meta::Check',          '0.009';
requires 'CPAN::Meta::Requirements',   '2.128';
requires 'CPAN::Perl::Releases',       '1.90';
requires 'Crypt::URandom',             '0.34';
requires 'Cwd::Guard',                 '0.04';
requires 'Daemon::Control',            '0.001006';
#requires 'Dancer',                     '1.3130';   #1
#requires 'Dancer2',                    '0.150000'; #1
requires 'Data::Dumper',               '2.154';
requires 'Date::Tiny',                 '1.04';
#requires 'DateTime',                   '1.12'; #1
requires 'DateTime::Tiny',             '1.04';
requires 'DBD::SQLite',                '1.42';
requires 'DBI',                        '1.631';
#requires 'DBIx::Class',                '0.082800';
#requires 'DBIx::Class::Schema::Loader', '0.07042';
requires 'DBIx::Connector',            '0.53';
requires 'DBIx::RunSQL',               '0.12';
requires 'Devel::Cycle',               '1.11';
requires 'Devel::CheckBin',            '0.02';
requires 'Devel::PPPort',              '3.24';
requires 'Devel::Dumpvar',             '1.06';
requires 'Devel::Refactor',            '0.05';
requires 'Digest::SHA',                '5.92';
requires 'Digest::SHA1',               '2.13';
#requires 'DigitalOcean',               '0.12';
#requires 'Dist::Zilla',                '5.020';
requires 'Email::MIME::Creator',       '1.926';
#requires 'Email::MIME::Kit',           '2.102014'; # Depends on Moose => #1
requires 'Email::Sender',              '1.300014';
requires 'Email::Sender::Simple',      '1.300014';
requires 'Email::Simple',              '2.203';
requires 'Email::Valid',               '1.195';
requires 'Encode',                     '2.62';
requires 'Exception::Class',           '1.38';
requires 'Excel::Writer::XLSX',        '0.77';
requires 'ExtUtils::MakeMaker',        '6.98';
#requires 'experimental',               '0.010'; #1
#requires 'ExtUtils::CBuilder',         '0.280219'; #1
#requires 'ExtUtils::Helpers',          '0.022'; #1
requires 'ExtUtils::Install',          '2.04';
requires 'ExtUtils::Manifest',         '1.68';
#requires 'ExtUtils::Embed',            '1.32'; # core
requires 'File::Copy::Recursive',      '0.38';
requires 'File::Find::Rule',           '0.33';
requires 'File::HomeDir',              '1.00';
requires 'File::Path',                 '2.09';
requires 'File::pushd',                '1.009';
requires 'File::Remove',               '1.52';
requires 'File::ShareDir',             '1.102';
requires 'File::Which',                '1.09';
requires 'Flickr::API',                '1.10';
#requires 'Geo::IP',                    '1.43';
requires 'HTML::Template',             '2.95';
requires 'HTML::Entities',             '3.69';
requires 'HTML::TableExtract',         '2.11';
requires 'HTML::Parser',               '3.71';
requires 'HTTP::Tiny',                 '0.049';
requires 'HTTP::Lite',                 '2.43';
requires 'HTTP::Request',              '6.00';
requires 'HTTP::Request::Common',      '6.04';
#requires 'HTTP::Server::Simple',       '0.44';
#requires 'HTTP::Server::Simple::CGI';             # does not have a version number!
requires 'HTTP::Tiny',                 '0.050';
#requires 'Hash::Merge::Simple',        '0.051'; # Depends on #1
requires 'IO::Compress::Gzip',         '2.066';
requires 'IO::Uncompress::Gunzip',     '2.066';
requires 'IO::Scalar',                 '2.110';
requires 'IO::String',                 '1.08';
requires 'IO::Socket',                 '1.25';
requires 'IO::Socket::IP',             '0.32';
requires 'IO::Socket::INET6',          '2.72';
requires 'IPC::Run',                   '0.92';
requires 'IPC::Run3',                  '0.048';
requires 'JSON',                       '2.90';
requires 'JSON::XS',                   '3.01';
#requires 'JSON::MaybeXS',              '1.002002';
requires 'List::MoreUtils',            '0.33';
requires 'List::Util',                 '1.41';
requires 'Locale::Codes',              '3.32';
requires 'local::lib',                 '2.000014';
requires 'Log::Contextual',            '0.006004';
requires 'Log::Dispatch',              '2.42';
requires 'Log::Log4perl',              '1.44';
requires 'LWP',                        '6.08';
requires 'LWP::Protocol::https',       '6.06';
#requires 'LWP::Protocol::PSGI',        '0.07'; # depends on #1
requires 'LWP::Simple',                '6.00';
requires 'LWP::UserAgent',             '6.06';
requires 'Marpa::R2',                  '2.094000';
requires 'Math::BigFloat',             '1.9993';
#requires 'Math::Random::ISAAC::XS';
requires 'MIME::Lite',                 '3.030';
requires 'MIME::Types',                '2.09';
requires 'Modern::Perl',               '1.20140107';
requires 'Module::Build',              '0.4210';
requires 'Module::CoreList',           '5.20140920';
requires 'Module::Manifest',           '1.08';
requires 'Module::Starter',            '1.62';
#requires 'MongoDB',                         '0.705.0.0';
requires 'Moo',                             '1.006000';
requires 'MooX::Options',                   '4.010';
#requires 'MooX::late',                      '0.015';
#requires 'MooX::Singleton',                 '1.20';
#requires 'Moose',                           '2.1213';
#requires 'MooseX::Singleton',               '0.29';
#requires 'MooseX::StrictConstructor',       '0.19';
#requires 'MooseX::Params::Validate',        '0.18';
#requires 'MooseX::Role::TraitConstructor',  '0.01';
#requires 'MooseX::Traits',                  '0.12';
#requires 'MooseX::Object::Pluggable',       '0.0013';
#requires 'MooseX::Role::Parameterized',     '1.08';
#requires 'MooseX::GlobRef';
#requires 'MooseX::InsideOut';
#requires 'MooseX::NonMoose';
#requires 'MooseX::Declare';
#requires 'MooseX::Method::Signatures';
#requires 'MooseX::Types';
#requires 'MooseX::Types::Structured';
#requires 'MooseX::Types::Path::Class';
#requires 'MooseX::Types::Set::Object';
#requires 'MooseX::Types::DateTime';
#requires 'MooseX::Getopt';
#requires 'MooseX::ConfigFromFile';
#requires 'MooseX::SimpleConfig';
#requires 'MooseX::App::Cmd';
#requires 'MooseX::Role::Cmd';
#requires 'MooseX::LogDispatch';
#requires 'MooseX::LazyLogDispatch';
#requires 'MooseX::Log::Log4perl';
#requires 'MooseX::Daemonize';
#requires 'MooseX::Param';
#requires 'MooseX::Iterator';
#requires 'MooseX::Clone';
#requires 'MooseX::Storage';
#requires 'MooseX::ClassAttribute';
#requires 'MooseX::SemiAffordanceAccessor';
requires 'Module::Build::ModuleInfo',       '0.4210';
requires 'Module::CoreList',                '5.20140920';
requires 'Module::Metadata',                '1.000024';
#requires 'Module::Version',                 '0.12'; # error: Failed to upconvert metadata to 1.1. Errors: Missing mandatory field, 'version' (version) [Validation: 1.0]
requires 'Mojolicious',                     '5.44';
#requires 'namespace::autoclean',            '0.20'; #1
requires 'Net::Config',                     '1.14';
requires 'Net::DNS',                        '0.80';
requires 'Net::SSLeay',                     '1.14';
#requires 'Net::Ping',                       '2.41';
#requires 'Net::Traceroute',                 '1.15';
#requires 'ORLite
#requires 'ORLite::Migrate
#requires 'Params::Util
#requires 'Parse::ErrorString::Perl
#requires 'Parse::ExuberantCTags
#requires 'Parallel::ForkManager
#requires 'Parse::CPAN::Meta',          '1.4414';
#requires 'Parse::Functions';
#requires 'Path::Tiny';
#requires 'Perl::Tidy';
#requires 'Perl::Critic
#requires 'Perl::Version
#requires 'Plack';
#requires 'Plack::Middleware::Debug
#requires 'Plack::Middleware::LogErrors
#requires 'Plack::Middleware::LogWarn
#requires 'Plack::Middleware::ReverseProxy
#requires 'PPIx::EditorTools::Outline';
#requires 'PDF::Create',                '1.08';
requires 'perlfaq',                         '5.0150045';
#requires 'Pod::Abstract
requires 'Pod::Checker',               '1.71';
#requires 'Pod::Coverage::Moose';
requires 'Pod::Perldoc',               '3.24';
requires 'Pod::Usage',                 '1.64';
#requires 'Pod::POM
#requires 'Pod::Simple
#requires 'Pod::Simple::XHTML
#requires 'Pod::Perldoc
#requires 'POD2::Base
#requires 'Portable',                    '1.22';
#requires 'PPI
#requires 'PPIx::EditorTools
#requires 'PPIx::Regexp
#requires 'Probe::Perl
#requires 'Regexp::Common',
#requires 'Regexp::Common::time',
#requires 'Scope::Upper';
requires 'Socket',                     '2.015';
requires 'Socket6',                    '0.25';
#requires 'Software::License
#requires 'Sort::Versions
#requires 'Spreadsheet::ParseExcel::Simple
#requires 'Spreadsheet::WriteExcel
#requires 'Spreadsheet::WriteExcel::Simple
#requires 'Starman',                    '0.4010';
requires 'Storable',                   '2.51';
#requires 'SVG',                        '2.59';
#requires 'Template',                   '2.26';
#requires 'Template::Tiny',             '1.12';
requires 'Term::ANSIColor',            '4.03';
requires 'Term::Cap',                  '1.16';
requires 'Test::Builder',              '1.001006';
requires 'Test::Class',                '0.46';
#requires 'Test::Class::Most',          '0.08';
requires 'Test::CleanNamespaces',      '0.16';
requires 'Test::Deep',                  '0.113';
#requires 'Test::Differences',           '0.62';  #1
requires 'Test::Exception',             '0.35';
requires 'Test::Fatal',                 '0.013';
requires 'Test::Memory::Cycle',         '1.04';
#requires 'Test::MockObject',           '1.20140408'; # depends on #1
requires 'Test::MockTime',              '0.13';
#requires 'Test::Mock::LWP';
#requires 'Test::MockModule';
requires 'Test::More',                  '1.001006';
#requires 'Test::Most',                  '0.34';  # 1
requires 'Test::NoWarnings',            '1.04';
requires 'Test::Output',                '1.03';
requires 'Test::Script',                '1.07';
requires 'Test::Without::Module',       '0.18';
#requires 'Test::WWW::Mechanize',        '1.44';
#requires 'Test::WWW::Mechanize::PSGI',  '0.35';
requires 'Test::Pod',                   '1.48';
requires 'Test::Pod::Coverage',         '1.10';
requires 'Test::Requires',              '0.08';
requires 'Test::LongString',            '0.16';
#requires 'Test::Ping',                  '0.17'; #1
requires 'Test::Harness',               '3.33';
requires 'Test::Trap',                  '0.2.4';
requires 'Test::Warn',                  '0.30';
#requires 'Test::Code::TidyAll',         '0.20';
requires 'Test::Perl::Critic',              '1.02';
#requires 'Term::ReadLine',                  '1.14';
#requires 'Term::ProgressBar::Simple',       '0.03';
requires 'Text::Balanced',                  '2.02';
requires 'Text::Diff',                      '1.41';
requires 'Text::FindIndent',                '0.10';
#requires 'Text::Patch'                      '1.8';
#requires 'Text::VimColor',                  '0.24';
#requires 'Text::Xslate',                    '3.3.3';
#requires 'Text::CSV',                       '1.32';
#requires 'Text::CSV_XS',                    '1.11';
requires 'threads',                         '1.96';
#requires 'Time::HiRes',                     '1.9726';
#requires 'Time::ParseDate',                 '2013.1113';
#requires 'Time::Tiny',                      '1.05';
requires 'Time::Piece',                     '1.29';
#requires 'Try::Tiny',                       '0.22';
#requires 'TryCatch',                        '1.003002';
requires 'Unicode::Collate',                '1.07';
requires 'Unicode::Normalize',              '1.18';
#requires 'URI',                             '1.64';
#requires 'URL::Encode::XS',                 '0.03';
requires 'Variable::Magic',                 '0.54';
#requires 'version',                         '0.9909';
#requires 'Web::Feed',                       '0.03';
#requires 'WebService::GData',               '0.06';
#requires 'WWW::Mechanize',                  '1.73';
#requires 'WWW::Mechanize::TreeBuilder',     '1.10003';
#requires 'XML::Atom',                       '0.41'; #1
requires 'XML::LibXML',                     '2.0116';  # it needs all kinds of parameters to build see build.sh and #2
#requires 'XML::Feed',                       '0.52'; #1
requires 'XML::Parser',                     '2.41';
#requires 'XML::RSS',                        '1.55';  #1
requires 'XML::SAX',                        '0.99';
requires 'XML::SAX::Writer',                '0.53';
requires 'XML::Simple',                     '2.20';
#requires 'XML::Twig',                       '3.48'; #1
requires 'XML::XPath',                      '1.13';
requires 'XML::NamespaceSupport',           '1.11';
requires 'YAML',                            '1.12';
#requires 'YAML::Tiny',                      '1.63'; #1

# Net::Server 2.007 failed: https://rt.cpan.org/Public/Bug/Display.html?id=91523
#mycpan --notest Net::Server
#
## mycpan PAR::Packer failed

## CGI::FormBuilder: lots of warnings like this:
## /bin/tar: Ignoring unknown extended header keyword `SCHILY.ino'
##### mycpan CGI::FormBuilder
#mycpan CGI::FormBuilder::Source::Perl
 



## Needs Term::Readline::Gnu but that fails because:
## Could not find neither libtermcap.a, libncurses.a, or libcurses.
## requires 'Debug::Client

# Win32
# Win32::Shortcut
# Win32::TieRegistry
# File::Glob::Windows

