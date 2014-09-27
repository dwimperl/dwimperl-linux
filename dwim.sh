#!/bin/sh

# The directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export PERL5OPT="-MDWIM"


# Warning: program compiled against libxml 209 using older 207
# Warning: XML::LibXML compiled against libxml2 20901, but runtime libxml2 is older 20706
# to avoid this we add the following:
export LD_LIBRARY_PATH=$DIR/c/lib

export PATH=$DIR/perl/bin:$PATH

