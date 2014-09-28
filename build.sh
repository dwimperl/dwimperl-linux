#!/bin/bash -e

# TODO: The output of some commands have been redirectd to /dev/null becaus they
# created too much output for Travis-CI. This needs to be improved.

echo set up environmet variables
PERL_VERSION=5.20.1

if [ "$DWIM_VERSION" = "" ]
then
    DWIM_VERSION=8
fi
if [ "$DWIM_BASE_VERSION" = "" ]
then
    DWIM_BASE_VERSION=7
fi
if [ "$DWIMPERL_COM" = "" ]
then
    DWIMPERL_COM=http://dwimperl.com/download
fi

OPENSSL=openssl-1.0.1i
LIBXML2=libxml2-2.9.1
ZLIB=zlib-1.2.8
EXPAT=expat-2.1.0

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
BUILD_TMP=/tmp
#ls -l $BUILD_TMP

ROOT=$BUILD_TMP/dwim
echo ROOT=$ROOT
[ -e $ROOT ] || mkdir $ROOT

PREFIX_PERL=$ROOT/$DWIMPERL_VERSION/perl
PREFIX_C=$ROOT/$DWIMPERL_VERSION/c

SOURCE_HOME=`pwd`
ORIGINAL_PATH=$PATH
#TEST_DIR=$BUILD_TMP/dwimperl_test
#BACKUP=$BUILD_TMP/dwimperl_backup

echo SOURCE_HOME=$SOURCE_HOME
#ls -l $SOURCE_HOME
cp $SOURCE_HOME/dwim.sh $ROOT/
#ls -l $ROOT

# prepare the local metadb for cpanm
# without this cpanm would complain that it cannot find the modules in the
# metaDB (especially if we are off-line)
# the gzip -k works on OSX but not on the Linux of Travis
PACKAGES=$SOURCE_HOME/local/cache/modules/02packages.details.txt
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
      cd $SOURCE_HOME
      
      which perl
      $PREFIX_PERL/bin/perl -v
      cp src/reloc_perl $PREFIX_PERL/bin/
  ;;

  cpanm)
      $PREFIX_PERL/bin/perl $SOURCE_HOME/src/cpanm --local-lib=$PREFIX_PERL --mirror file://$SOURCE_HOME/local/cache/ --mirror-only App::cpanminus
#      $PREFIX_PERL/bin/perl src/cpanm --local-lib=$PREFIX_PERL --mirror file://$SOURCE_HOME/local/cache/ local::lib
  ;;

  dwim)
      cd $SOURCE_HOME/src/DWIM
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose .
  ;;

  openssl)
      cd $BUILD_TMP
      tar xzf $SOURCE_HOME/src/$OPENSSL.tar.gz
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


  get_base_perl)
      cd $BUILD_TMP
      wget $DWIMPERL_COM/$BASE_DWIMPERL_VERSION.tar.gz
      tar -mxzf $BASE_DWIMPERL_VERSION.tar.gz
      echo BASE_DWIMPERL_VERSION=$BASE_DWIMPERL_VERSION
      echo ROOT/DWIMPERL_VERSION=$ROOT/$DWIMPERL_VERSION
      mv $BASE_DWIMPERL_VERSION $ROOT/$DWIMPERL_VERSION
      $PREFIX_PERL/bin/perl -v
  ;;

  # TODO: See Issue #2
  xml-libxml)
      #export XMLPREFIX=$PREFIX_C
      #echo $XMLPREFIX
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose  --configure-args "LIBS='-L$PREFIX_C/lib/' INC='-I$PREFIX_C/include/ -I/$PREFIX_C/include/libxml2'" XML::LibXML
  ;;

  xml-parser)
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose --configure-args "EXPATLIBPATH=$PREFIX_C/lib EXPATINCPATH=$PREFIX_C/include" XML::Parser
  ;;

  notest)
      source $ROOT/dwim.sh
      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --notest IPC::System::Simple
      # see https://travis-ci.org/dwimperl/dwimperl-linux/builds/36451393

      $PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --notest Class::Singleton
      # Test counting restarts after 1 due to destructor timing. see https://rt.cpan.org/Public/Bug/Display.html?id=23568
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
      #$PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose DateTime
      #$PREFIX_PERL/bin/perl $PREFIX_PERL/bin/cpanm --mirror file://$SOURCE_HOME/local/cache/ --mirror-only --verbose MongoDB
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
      cd $ROOT
      cp $SOURCE_HOME/src/reloc_perl $PREFIX_PERL/bin/
      chmod u+wx $PREFIX_PERL/bin/*
      tar -czf $DWIMPERL_VERSION.tar.gz $DWIMPERL_VERSION
      echo GENERATED_ZIP_FILE=$ROOT/$DWIMPERL_VERSION.tar.gz
  ;;

  *)
    echo "Missing or unrecognized parameter $1"
    echo perl                - build perl
    echo cpanm               - install cpanm
    echo get_base_perl       - download and unzip an earlier release
    echo modules             - install all the modules listed in the cpanfile
    echo test_perl           - test if perl has the expected version number t/00-perl.t
    echo test_cpanfile       - test if modules listed in the cpanfile can be loaded 
    echo test_all            - test if we can load modules
    echo outdate             - list the modules that have newer versions on CPAN
    echo zip                 - create the final zip file
    exit 1
  ;;
esac

