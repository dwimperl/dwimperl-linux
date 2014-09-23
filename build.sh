#!/bin/sh -e


echo set up environment variables
PERL_VERSION=5.20.1
SUBVERSION=1
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

DWIMPERL_VERSION=dwimperl-$PLATFORM_NAME-$PERL_VERSION-$SUBVERSION-$ARCHITECTURE
echo $DWIMPERL_VERSION
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
rm -f local/cache/modules/02packages.details.txt.gz
gzip -k local/cache/modules/02packages.details.txt


export PATH=$PREFIX_PERL/bin:$ORIGINAL_PATH

case $1 in
  perl)
    echo "Building Perl"
    tar xzf src/$PERL_SOURCE_ZIP_FILE
    cd $PERL_SOURCE_VERSION
    ./Configure -des -Duserelocatableinc -Dprefix=$PREFIX_PERL
	# -Dusethreads
    make > /dev/null
    TEST_JOBS=3 make test
    make install > /dev/null
    cd $BUILD_HOME
    
    which perl
    $PREFIX_PERL/bin/perl -v
  ;;

  cpanm)
    cd $BUILD_HOME
    $PREFIX_PERL/bin/perl src/cpanm --local-lib=$PREFIX_PERL --mirror file://$BUILD_HOME/local/cache/ --mirror-only App::cpanminus
#    $PREFIX_PERL/bin/perl src/cpanm --local-lib=$PREFIX_PERL --mirror file://$BUILD_HOME/local/cache/ local::lib
  ;;

  get_vanilla_perl)
      wget http://dwimperl.com/download/dwimperl-linux-5.20.1-1-x86_64.tar.gz
      tar xzf dwimperl-linux-5.20.1-1-x86_64.tar.gz
      mv dwimperl-5.20.1-1-x86_64 $ROOT/$DWIMPERL_VERSION
      $PREFIX_PERL/bin/perl -v
  ;;


  modules)
      cd $BUILD_HOME
      HARNESS_OPTIONS=j3
      $PREFIX_PERL/bin/cpanm --installdeps --mirror file://$BUILD_HOME/local/cache/ --mirror-only .
  ;;

  test_perl)
      cd $BUILD_HOME
      $PREFIX_PERL/bin/prove t/00-perl.t
  ;;

  test_all)
      cd $BUILD_HOME
      $PREFIX_PERL/bin/prove
  ;;

  outdate)
      $PREFIX_PERL/bin/cpan-outdated --verbose
  ;;

  zip)
      cd $ROOT
      tar czf $DWIMPERL_VERSION.tar.gz $DWIMPERL_VERSION
  ;;

  *)
    echo "Missing or unrecognized parameter $1"
    echo perl                - build perl
    echo cpanm               - install cpanm
    echo get_vanilla_perl    - download and unzip the vanialla perl
    echo modules             - install all the modules listed in the cpanfile
    echo test_perl           - test if perl has the expected version number t/00-perl.t
    echo test_all            - test if we can load modules
    echo outdate             - list the modules that have newer versions on CPAN
    echo zip                 - create the final zip file
  ;;
esac

