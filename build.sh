#!/bin/sh -e


echo set up environment variables
PERL_VERSION=5.20.1
SUBVERSION=1
PLATFORM=`uname`
echo PLATFORM=$PLATFORM
if [ "$PLATFORM" = "Darwin" ]
then
  ARCHITECTURE=`uname -m`
else
  ARCHITECTURE=`uname -i`
fi
echo ARCHITECTURE=$ARCHITECTURE


PERL_SOURCE_VERSION=perl-$PERL_VERSION
PERL_SOURCE_ZIP_FILE=$PERL_SOURCE_VERSION.tar.gz

DWIMPERL_VERSION=dwimperl-$PERL_VERSION-$SUBVERSION-$ARCHITECTURE
ROOT=~/$DWIMPERL_VERSION
PREFIX_PERL=$ROOT/perl
PREFIX_C=$ROOT/c

BUILD_HOME=`pwd`
ORIGINAL_PATH=$PATH
TEST_DIR=~/dwimperl_test
BACKUP=~/dwimperl_backup

echo BUILD_HOME=$BUILD_HOME


export PATH=$PREFIX_PERL/bin:$ORIGINAL_PATH

case $1 in
  perl)
    echo "Building Perl"
    tar xzf src/$PERL_SOURCE_ZIP_FILE
    cd $PERL_SOURCE_VERSION
    ./Configure -des -Duserelocatableinc -Dprefix=$PREFIX_PERL
	# -Dusethreads
    make
    TEST_JOBS=3 make test
    make install
    cd $BUILD_HOME
    
    which perl
    $PREFIX_PERL/bin/perl -v
    $PREFIX_PERL/bin/perl src/cpanm --local-lib=$PREFIX_PERL --mirror file://$BUILD_HOME/local/cache/ App::cpanminus
#    $PREFIX_PERL/bin/perl src/cpanm --local-lib=$PREFIX_PERL --mirror file://$BUILD_HOME/local/cache/ local::lib
  ;;


  modules)
    $PREFIX_PERL/bin/cpanm --installdeps --mirror file://$BUILD_HOME/local/cache/ .
  ;;

  test)
    $PREFIX_PERL/bin/prove
  ;;

  outdate)
    $PREFIX_PERL/bin/cpan-outdated --verbose
  ;;

  *)
    echo "Missing or unrecognized parameter $1"
  ;;
esac

