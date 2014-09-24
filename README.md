[![Build Status](https://travis-ci.org/dwimperl/dwimperl-linux.png)](https://travis-ci.org/dwimperl/dwimperl-linux)


DWIM Perl for Linux
====================

Downloading
-----------

The released package of DWIM Perl for Linux can be found at http://dwimperl.com/linux.html

Create derivative distribution
------------------------------

* Fork the repository
* Add and upgrade modules (see below)
* Build new version (see below)


Building manually from source
------------------------------

If you'd like to build DWIM Perl for linux yourself you can do so by the following these instructions:

Install the prerequisites which are 'make' and 'gcc'

```
wget https://github.com/dwimperl/dwimperl-linux/archive/master.zip```
    # Note: in some cases the file downloaded by ```wget``` will have no .zip extension.
    # You might want to rename the file before proceeding
unzip master.zip
cd dwimperl-linux-master
./build.sh perl        # build perl
./build.sh cpanm       # install cpanm
./build.sh modules     # install all the modules
./build.sh test_all    # run a sanity check loading some of the modules we installed
./build.sh zip         # create the tar.gz to be distributed
```

TBD: building based on existing DWIM Perl
TBD: building on Digital Ocean



Upgrade Perl
-------------

Look at http://www.cpan.org/src/README.html for the latest stable release of Perl

```
cd src/
wget http://www.cpan.org/src/5.0/perl-5.20.1.tar.gz
```

Update the PERL_VERSION in build.sh

OpenSSL
-------

OpenSSL is needed by Net::SSLEay which is needed by LWP::Protocol::https
and Business::PayPal and more.
Look at http://www.openssl.org/  and at http://www.openssl.org/news/
11-Feb-2013:	openssl-1.0.1e.tar.gz
...
06-Aug-2014:    openssl-1.0.1i.tar.gz

```
cd src/
wget http://www.openssl.org/source/openssl-1.0.1i.tar.gz
```

Update the OPENSSL entry in build.sh


libxml2
-------

# libxml2 and zlib are needed for XML::LibXML
# See http://xmlsoft.org/ and ftp://xmlsoft.org/libxml2/

```
cd src
wget ftp://xmlsoft.org/libxml2/libxml2-2.9.1.tar.gz
```

Update the LIBXML2 variable in build.sh


Upgrade cpanm used for installing cpanm
---------------------------------------

Note: This copy of cpanm is only used to install the latest version of cpanm from CPAN.
The rest of the modules are then installed using *that* version of cpanm.

```
cd src/
wget wget https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm
```

Add CPAN Modules
----------------

Edit ```cpanfile``` add the names of the new modules.
Run ```carton```. It will download the zip files and install the modules.
Add the zip files to Git.
(Problem: It seems that if a prerequisite is already installed in the perl we are using,
this will not download the zip file of that prerequisites either. I think adding the prerequisite
explicitely to the cpanfile helped.)

Upgrade CPAN Modules
---------------------

Run ```./build.sh outdated``` to list the distributions that have newer versions on CPAN.
Edit ```cpanfile``` and put the new version number after the name of the module:
```requires 'Module::Name', '3.14';```
then run ```carton``` to update the ```cpanfile.snapshot```


