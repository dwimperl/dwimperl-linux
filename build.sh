#!/bin/bash -e

# TODO: The output of some commands have been redirected to /dev/null because they
# created too much output for Travis-CI. This needs to be improved.

function run {
    echo "$1   >   $LOG_DIR/$2"
    $1 > $LOG_DIR/$2 2>&1 
}

printf "\nSet up environmet variables\n\n"
###################################################
## Perl 5
# Look at http://www.cpan.org/src/README.html for the latest stable release of Perl
PERL_VERSION=5.26.1

## OpenSSL is needed by Net::SSLEay which is needed by LWP::Protocol::https
# and Business::PayPal and more.
# Look at http://www.openssl.org/  and at http://www.openssl.org/news/
# 2013.02.11:  openssl-1.0.1e.tar.gz
# 2014.08.06:  openssl-1.0.1i.tar.gz
# 2015.01.22:  openssl-1.0.2.tar.gz
# 2015.10.16:  openssl-1.0.2d.tar.gz
OPENSSL=openssl-1.0.2d

## libxml2 and zlib are needed for XML::LibXML
# See http://xmlsoft.org/ and ftp://xmlsoft.org/libxml2/
# 2014.10.16: libxml2-2.9.2
LIBXML2=libxml2-2.9.2

## zlib
# See http://www.zlib.net/
ZLIB=zlib-1.2.8

## expat
# XML::Parser needs expat.
# Visit http://sourceforge.net/projects/expat/
# and http://sourceforge.net/projects/expat/files/expat/ to see what is the latest
# 2012.03.24 expat-2.1.0
EXPAT=expat-2.1.0

## Geo::IP
# Needed by Geo::IP
# Visit http://dev.maxmind.com/geoip/legacy/downloadable/
# that links to https://github.com/maxmind/geoip-api-c/releases
# 2015.02.26 1.6.5
# 2015.07.28 1.6.6
GEOIP=GeoIP-1.6.6
###################################################



if [ "$DWIM_VERSION" = "" ]
then
    DWIM_VERSION=1
fi
if [ "$DWIM_BASE_VERSION" = "" ]
then
    DWIM_BASE_VERSION=0
fi
if [ "$DWIMPERL_COM" = "" ]
then
    DWIMPERL_COM=http://dwimperl.com/download
fi

if [ "$GEOIP_DATA_URL" = "" ]
then
    GEOIP_DATA_URL=http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
fi


# If you want to build DWIM Perl based on an earlier version
# the script will download that version from http://dwimperl.com/download
# You can avoid the repeated downloading of the file by manually downloading it
# and the configuring the DWIMPERL_COM environment variable to point to the directory
# where the downloaded file lives in. (untested feature)
# DWIMPERL_COM=file:///path/to/dwimperl.com/ ./build.sh ....

PLATFORM=`uname`
PLATFORM_NAME=$(echo $PLATFORM | tr '[:upper:]' '[:lower:]')

if [ "$PLATFORM" = "Darwin" ]
then
  ARCHITECTURE=`uname -m`
else
  ARCHITECTURE=`uname -i`
fi

PERL_SOURCE_VERSION=perl-$PERL_VERSION
PERL_SOURCE_ZIP_FILE=$PERL_SOURCE_VERSION.tar.gz
OPENSSL_SOURCE_ZIP_FILE=$OPENSSL.tar.gz

DWIMPERL_VERSION=dwimperl-$PLATFORM_NAME-$PERL_VERSION-$DWIM_VERSION-$ARCHITECTURE
BASE_DWIMPERL_VERSION=dwimperl-$PLATFORM_NAME-$PERL_VERSION-$DWIM_BASE_VERSION-$ARCHITECTURE

BUILD_TMP=/tmp

ROOT=$BUILD_TMP/$DWIMPERL_VERSION
[ -e $ROOT ] || mkdir $ROOT

LOG_DIR=$BUILD_TMP/log
PREFIX_PERL=$ROOT/perl
PREFIX_C=$ROOT/c
SOURCE_HOME=/vagrant

# prepare the local metadb for cpanm
# without this cpanm would complain that it cannot find the modules in the
# metaDB (especially if we are off-line)
# the gzip -k works on OSX but not on the Linux of Travis
PACKAGES=$SOURCE_HOME/local/cache/modules/02packages.details.txt
PACKAGES_ZIP=$PACKAGES.gz

printf "DWIMPERL_COM     = %s\n" $DWIMPERL_COM
printf "PLATFORM         = %s\n" $PLATFORM
printf "PLATFORM_NAME    = %s\n" $PLATFORM_NAME
printf "ARCHITECTURE     = %s\n" $ARCHITECTURE
printf "DWIMPERL_VERSION = %s\n" $DWIMPERL_VERSION
printf "ROOT             = %s\n" $ROOT
printf "SOURCE_HOME      = %s\n" $SOURCE_HOME
printf "LOG_DIR          = %s\n" $LOG_DIR
printf "PREFIX_PERL      = %s\n" $PREFIX_PERL
#echo PACKAGES=$PACKAGES
#echo PACKAGES_ZIP=$PACKAGES_ZIP
printf "==================\n"
#[ ! -e $PACKAGES_ZIP ] || [ $PACKAGES -nt $PACKAGES_ZIP ] && (cat $PACKAGES | gzip > $PACKAGES_ZIP)

ORIGINAL_PATH=$PATH
export PATH=$PREFIX_PERL/bin:$ORIGINAL_PATH

[ -e $LOG_DIR ] || mkdir $LOG_DIR

case $1 in
  all)
      $0 perl
      $0 cpanm
      $0 dwim
      $0 external
  ;;

  download)
      echo "Downloading"
      cd $SOURCE_HOME/src
      if [ ! -e $SOURCE_HOME/src/$PERL_SOURCE_ZIP_FILE ]; then
         run "wget -q http://www.cpan.org/src/5.0/$PERL_SOURCE_ZIP_FILE"
      fi
      if [ ! -e $SOURCE_HOME/src/$OPENSSL_SOURCE_ZIP_FILE ]; then
         run "wget http://www.openssl.org/source/$OPENSSL_SOURCE_ZIP_FILE"
      fi
  ;;

  perl)
      echo "Building Perl"
      cd $BUILD_TMP
      [ -e $PERL_SOURCE_VERSION ] && echo "Directory $PERL_SOURCE_VERSION already exists" && exit
      run "tar -xzf $SOURCE_HOME/src/$PERL_SOURCE_ZIP_FILE" perl_unzip.log
      cd $PERL_SOURCE_VERSION
      run "./Configure -des -Duserelocatableinc -Dprefix=$PREFIX_PERL" perl_config.log
	  # -Dusethreads
      run make perl_make.log
      TEST_JOBS=3 
      run "make test" perl_test.log
      run "make install" perl_install.log

      $PREFIX_PERL/bin/perl -v
      #cp $SOURCE_HOME/src/reloc_perl $PREFIX_PERL/bin/
      #cp $SOURCE_HOME/dwim.sh $ROOT/
      #chmod +x $ROOT/dwim.sh
      cd $BUILD_TMP
      rm -rf $PERL_SOURCE_VERSION
  ;;

  cpanm)
      $PREFIX_PERL/bin/perl $SOURCE_HOME/src/cpanm --local-lib=$PREFIX_PERL --mirror file://$SOURCE_HOME/local/cache/ --mirror-only App::cpanminus
#      $PREFIX_PERL/bin/perl src/cpanm --local-lib=$PREFIX_PERL --mirror file://$SOURCE_HOME/local/cache/ local::lib
  ;;

  dwim)
      cd $SOURCE_HOME/src/DWIM
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose .
  ;;

  external)
      $0 openssl
      $0 libxml2
      $0 zlib
      $0 expat
      $0 geoip
  ;;

  openssl)
      cd $BUILD_TMP
      tar xzf $SOURCE_HOME/src/$OPENSSL_SOURCE_ZIP_FILE
      cd $OPENSSL

      # instead of patching broken PODs that cause "make install" to fail we just remove them:
      # (This was needed in  openssl-1.0.1e.tar.gz I have not tested it later)
      #rm -rf doc
      #mkdir doc
      #mkdir doc/apps
      #mkdir doc/crypto
      #mkdir doc/ssl
      #cp $SOURCE_HOME/src/empty.pod doc/apps/
      #cp $SOURCE_HOME/src/empty.pod doc/crypto/
      #cp $SOURCE_HOME/src/empty.pod doc/ssl/
      ./config --prefix=$PREFIX_C -fPIC
      make
      make test
      make install
  ;;

  libxml2)
      cd $BUILD_TMP
      tar xzf $SOURCE_HOME/src/$LIBXML2.tar.gz
      cd $LIBXML2
      ./configure --prefix $PREFIX_C --without-python
      make
      make install
  ;;

  zlib)
      cd $BUILD_TMP
      tar xzf $SOURCE_HOME/src/$ZLIB.tar.gz
      cd $ZLIB
      ./configure --prefix $PREFIX_C
      make
      make install
  ;;

  expat)
      cd $BUILD_TMP
      tar xzf $SOURCE_HOME/src/$EXPAT.tar.gz
      cd $EXPAT
      ./configure --prefix $PREFIX_C
      make
      make install
  ;;
## If you ever happen to want to link against installed libraries
## in a given directory, LIBDIR, you must either use libtool, and
## specify the full pathname of the library, or use the `-LLIBDIR'
## flag during linking and do at least one of the following:
##    - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
##      during execution
##    - add LIBDIR to the `LD_RUN_PATH' environment variable
##      during linking
##    - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
##    - have your system administrator add LIBDIR to `/etc/ld.so.conf'
## 
## See any operating system documentation about shared libraries for
## more information, such as the ld(1) and ld.so(8) manual pages.

  geoip)
      cd $BUILD_TMP
      tar xzf $SOURCE_HOME/src/$GEOIP.tar.gz
      cd $GEOIP
      ./configure --prefix $PREFIX_C
      make
      make check
      make install
  ;;

  get_base_perl)
      cd $BUILD_TMP
      wget $DWIMPERL_COM/$BASE_DWIMPERL_VERSION.tar.gz
      tar -mxzf $BASE_DWIMPERL_VERSION.tar.gz
      echo BASE_DWIMPERL_VERSION=$BASE_DWIMPERL_VERSION
      echo ROOT=$ROOT
      mv $BASE_DWIMPERL_VERSION $ROOT
      cp $SOURCE_HOME/dwim.sh $ROOT/
      chmod +x $ROOT/dwim.sh
      $PREFIX_PERL/bin/perl -v
  ;;


  specials)
      source $ROOT/dwim.sh
      $0 notest IPC::System::Simple
      # see #3

      $0 notest Class::Singleton
      # see #5

      $0 xml-libxml
      $0 xml-parser
      $0 geo-ip
  ;;


  geo-ip)
      source $ROOT/dwim.sh
      cd $BUILD_TMP
      wget $GEOIP_DATA_URL
      gunzip GeoIP.dat.gz
      mkdir -p $PREFIX_C/share/GeoIP/
      mv GeoIP.dat $PREFIX_C/share/GeoIP/
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose Geo::IP
      rm -f $PREFIX_C/share/GeoIP/GeoIP.dat
  ;;

  # TODO: See Issue #2
  xml-libxml)
      #export XMLPREFIX=$PREFIX_C
      #echo $XMLPREFIX
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --configure-args "LIBS='-L$PREFIX_C/lib/' INC='-I$PREFIX_C/include/ -I/$PREFIX_C/include/libxml2'" XML::LibXML
  ;;

  xml-parser)
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --configure-args "EXPATLIBPATH=$PREFIX_C/lib EXPATINCPATH=$PREFIX_C/include" XML::Parser
  ;;


  verbose)
      source $ROOT/dwim.sh
      CPAN_MODULE=$2
      echo MODULE=$CPAN_MODULE
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose $CPAN_MODULE
  ;;

  notest)
      source $ROOT/dwim.sh
      CPAN_MODULE=$2
      echo MODULE=$CPAN_MODULE
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose --notest $CPAN_MODULE
  ;;

  try)
      #$PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose Portable
      #export PERL5OPT="-MPortable $PERL5OPT"
      #cd $SOURCE_HOME
      #echo $ROOT
      #ls -l $ROOT
      source $ROOT/dwim.sh
      #$PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose IPC::System::Simple
      #$PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose Class::Singleton
      #$PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose MongoDB
      #$PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose XML::Feed
      #$PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose Compress::Bzip2
      #$PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose CPAN::Checksums
  ;;

  modules)
      # needed to build Net::SSLeay
      export OPENSSL_PREFIX=$PREFIX_C
      export XMLPREFIX=$PREFIX_C
      source $ROOT/dwim.sh

      cd $SOURCE_HOME
      HARNESS_OPTIONS=j3
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --installdeps --mirror file://$SOURCE_HOME/local/cache/ --mirror-only .
  ;;

  test_perl)
      cd $SOURCE_HOME
      source $ROOT/dwim.sh
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/prove t/00-perl.t
  ;;

  test_cpanfile)
      cd $SOURCE_HOME
      source $ROOT/dwim.sh
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/prove t/01-cpanfile.t
  ;;


  test_all)
      cd $SOURCE_HOME
      source $ROOT/dwim.sh
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/prove
  ;;

  outdate)
      source $ROOT/dwim.sh
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpan-outdated --verbose
  ;;

  zip)
      cd $BUILD_TMP
      cp $SOURCE_HOME/src/reloc_perl $PREFIX_PERL/bin/
      cp $SOURCE_HOME/cpanfile $ROOT/
      cp $SOURCE_HOME/src/README $ROOT/
      chmod u+wx $PREFIX_PERL/bin/*
      tar -czf $DWIMPERL_VERSION.tar.gz $DWIMPERL_VERSION
      echo GENERATED_ZIP_FILE=$BUILD_TMP/$DWIMPERL_VERSION.tar.gz
  ;;

  *)
    printf "Missing or unrecognized parameter $1\n"
    printf "Available parameters:\n"
    printf "\n"
    printf "perl                - build perl\n"
    printf "cpanm               - install cpanm\n"
    printf "get_base_perl       - download and unzip an earlier release\n"
    printf "modules             - install all the modules listed in the cpanfile\n"
    printf "test_perl           - test if perl has the expected version number t/00-perl.t\n"
    printf "test_cpanfile       - test if modules listed in the cpanfile can be loaded\n"
    printf "test_all            - test if we can load modules\n"
    printf "outdate             - list the modules that have newer versions on CPAN\n"
    printf "zip                 - create the final zip file\n"
    exit 1
  ;;
esac


