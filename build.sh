#!/bin/sh -e


echo set up environment variables
PERL_VERSION=5.20.1
SUBVERSION=1
PLATFORM=`uname`
echo $PLATFORM
if [ "$PLATFORM" = "Darwin" ]
then
  ARCHITECTURE=`uname -m`
else
  ARCHITECTURE=`uname -i`
fi
echo $ARCHITECTURE


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

export PATH=$PREFIX_PERL/bin:$ORIGINAL_PATH

case $1 in
  perl)
    echo "Building Perl"
    tar xzf src/$PERL_SOURCE_ZIP_FILE
    cd $PERL_SOURCE_VERSION
    ./Configure -des -Duserelocatableinc -Dprefix=$PREFIX_PERL
    make
    make test
    make install
    cd $BUILD_HOME
    
    which perl
    perl -v
  ;;

  modules)
    cpanm --installdeps .
  ;;
  test)
    prove
  ;;

  *)
    echo "Missing or unrecognized parameter '$1'"
  ;;
esac

