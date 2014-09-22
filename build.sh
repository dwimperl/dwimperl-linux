#!/bin/sh -e

echo set up environment variables
PERL_VERSION=5.20.1
SUBVERSION=1
ARCHITECTURE=`uname -i`

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

tar xzf src/$PERL_SOURCE_ZIP_FILE
cd $PERL_SOURCE_VERSION
./Configure -des -Duserelocatableinc -Dprefix=$PREFIX_PERL
make
make test
make install
cd $BUILD_HOME

export PATH=$PREFIX_PERL/bin:$ORIGINAL_PATH
which perl
perl -v


