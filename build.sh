#!/bin/sh -e

# TODO: The output of some commands have been redirectd to /dev/null becaus they
# created too much output for Travis-CI. This needs to be improved.

echo set up environmet variables
PERL_VERSION=5.20.1

if [ "$DWIM_VERSION" = "" ]
then
    DWIM_VERSION=5
fi
if [ "$DWIM_BASE_VERSION" = "" ]
then
    DWIM_BASE_VERSION=4
fi
if [ "$DWIMPERL_COM" = "" ]
then
    DWIMPERL_COM=http://dwimperl.com/download
fi

OPENSSL=openssl-1.0.1i
LIBXML2=libxml2-2.9.1
ZLIB=zlib-1.2.8

# If you want to build DWIM Perl based on an earlier version
# the script will download that version from http://dwimperl.com/download
# You can avoid the repeated downloading of the file by manually downloading it
# and the configuring the DWIMPERL_COM environment variable to point to the directory
# where the downloaded file lives in. (untested feature)
# DWIMPERL_COM=file:///path/to/dwimperl.com/ ./build.sh ....
echo DWIMPERL_COM=$DWIMPERL_COM

PLATFORM=`uname`
PLATFORM_NAME=$(echo $PLATFORM | tr '[:upper:]' '[:lower:]')
echo PLATFORM=$PLATFORM
echo PLATFORM_NAME=$PLATFORM_NAME
if [ "$PLATFORM" = "Darwin" ]
then
  ARCHITECTURE=`uname -m`
else
  ARCHITECTURE=`uname -i`
fi
echo ARCHITECTURE=$ARCHITECTURE


PERL_SOURCE_VERSION=perl-$PERL_VERSION
PERL_SOURCE_ZIP_FILE=$PERL_SOURCE_VERSION.tar.gz

DWIMPERL_VERSION=dwimperl-$PLATFORM_NAME-$PERL_VERSION-$DWIM_VERSION-$ARCHITECTURE
BASE_DWIMPERL_VERSION=dwimperl-$PLATFORM_NAME-$PERL_VERSION-$DWIM_BASE_VERSION-$ARCHITECTURE
echo DWIMPERL_VERSION=$DWIMPERL_VERSION
ROOT=~
PREFIX_PERL=$ROOT/$DWIMPERL_VERSION/perl
PREFIX_C=$ROOT/$DWIMPERL_VERSION/c

BUILD_HOME=`pwd`
ORIGINAL_PATH=$PATH
#TEST_DIR=$ROOT/dwimperl_test
#BACKUP=$ROOT/dwimperl_backup

echo BUILD_HOME=$BUILD_HOME


# prepare the local metadb for cpanm
# without this cpanm would complain that it cannot find the modules in the
# metaDB (especially if we are off-line)
# the gzip -k works on OSX but not on the Linux of Travis
PACKAGES=local/cache/modules/02packages.details.txt
PACKAGES_ZIP=$PACKAGES.gz
#echo PACKAGES=$PACKAGES
#echo PACKAGES_ZIP=$PACKAGES_ZIP
[ ! -e $PACKAGES_ZIP ] || [ $PACKAGES -nt $PACKAGES_ZIP ] && (cat $PACKAGES | gzip > $PACKAGES_ZIP)


export PATH=$PREFIX_PERL/bin:$ORIGINAL_PATH

case $1 in
  perl)
      echo "Building Perl"
      [ -e $PERL_SOURCE_VERSION ] && echo "Directory $PERL_SOURCE_VERSION already exists" && exit
      tar -xzf src/$PERL_SOURCE_ZIP_FILE
      cd $PERL_SOURCE_VERSION
      ./Configure -des -Duserelocatableinc -Dprefix=$PREFIX_PERL
	  # -Dusethreads
      make
      TEST_JOBS=3 make test
      make install
      cd $BUILD_HOME
      
      which perl
      $PREFIX_PERL/bin/perl -v
      cp src/reloc_perl $PREFIX_PERL/bin/
  ;;

  cpanm)
      cd $BUILD_HOME
      $PREFIX_PERL/bin/perl src/cpanm --local-lib=$PREFIX_PERL --mirror file://$BUILD_HOME/local/cache/ --mirror-only App::cpanminus
#      $PREFIX_PERL/bin/perl src/cpanm --local-lib=$PREFIX_PERL --mirror file://$BUILD_HOME/local/cache/ local::lib
  ;;

  openssl)
      cd $BUILD_HOME
      tar xzf src/$OPENSSL.tar.gz
      cd $OPENSSL

      # instead of patching broken PODs that cause "make install" to fail we just remove them:
      # (This was needed in  openssl-1.0.1e.tar.gz I have not tested it later)
      #rm -rf doc
      #mkdir doc
      #mkdir doc/apps
      #mkdir doc/crypto
      #mkdir doc/ssl
      #cp $BUILD_HOME/src/empty.pod doc/apps/
      #cp $BUILD_HOME/src/empty.pod doc/crypto/
      #cp $BUILD_HOME/src/empty.pod doc/ssl/
      ./config --prefix=$PREFIX_C -fPIC
      make
      make test
      make install
  ;;

  libxml2)
      cd $BUILD_HOME
      tar xzf src/$LIBXML2.tar.gz
      cd $LIBXML2
      ./configure --prefix $PREFIX_C --without-python
      make
      make install
  ;;

  zlib)
      cd $BUILD_HOME
      tar xzf src/$ZLIB.tar.gz
      cd $ZLIB
      ./configure --prefix $PREFIX_C
      make
      make install
  ;;

  get_vanilla_perl)
      wget $DWIMPERL_COM/$BASE_DWIMPERL_VERSION.tar.gz
      tar -mxzf $BASE_DWIMPERL_VERSION.tar.gz
      echo BASE_DWIMPERL_VERSION=$BASE_DWIMPERL_VERSION
      echo ROOT/DWIMPERL_VERSION $ROOT/$DWIMPERL_VERSION
      mv $BASE_DWIMPERL_VERSION $ROOT/$DWIMPERL_VERSION
      $PREFIX_PERL/bin/perl -v
  ;;

  try)
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$BUILD_HOME/local/cache/ --mirror-only --verbose Test::Differences
  ;;

  modules)
      # needed to build Net::SSLeay
      export OPENSSL_PREFIX=$PREFIX_C

      cd $BUILD_HOME
      HARNESS_OPTIONS=j3
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --installdeps --mirror file://$BUILD_HOME/local/cache/ --mirror-only .
  ;;

  test_perl)
      cd $BUILD_HOME
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/prove t/00-perl.t
  ;;

  test_cpanfile)
      cd $BUILD_HOME
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/prove t/01-cpanfile.t
  ;;


  test_all)
      cd $BUILD_HOME
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/prove
  ;;

  outdate)
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpan-outdated --verbose
  ;;

  zip)
      cd $ROOT
      cp $BUILD_HOME/src/reloc_perl $PREFIX_PERL/bin/
      chmod u+wx $PREFIX_PERL/bin/*
      tar -czf $DWIMPERL_VERSION.tar.gz $DWIMPERL_VERSION
      echo GENERATED_ZIP_FILE=$ROOT/$DWIMPERL_VERSION.tar.gz
  ;;

  *)
    echo "Missing or unrecognized parameter $1"
    echo perl                - build perl
    echo cpanm               - install cpanm
    echo get_vanilla_perl    - download and unzip the vanialla perl
    echo modules             - install all the modules listed in the cpanfile
    echo test_perl           - test if perl has the expected version number t/00-perl.t
    echo test_cpanfile       - test if modules listed in the cpanfile can be loaded 
    echo test_all            - test if we can load modules
    echo outdate             - list the modules that have newer versions on CPAN
    echo zip                 - create the final zip file
  ;;
esac

