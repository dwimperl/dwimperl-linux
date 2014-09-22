
INSTALL
--------

wget https://github.com/dwimperl/dwimperl-linux/archive/master.zip
unzip master.zip
cd 
./build.sh


wget https://github.com/dwimperl/dwimperl-linux/archive/experiment-0.01.zip
unzip experiment-0.01.zip
cd dwimperl-linux-experiment-0.01
./build.sh


How it was created, how to upgrade
----------------------------------


*Perl:*

Look at http://www.cpan.org/src/README.html for the latest
cd src/
wget http://www.cpan.org/src/5.0/perl-5.20.1.tar.gz


*cpanm*

cd src/
wget wget https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm


*CPAN Modules*

Edit ```cpanfile``` add the name of the required module.
Run ```carton```. It will download the zip files and install the modules.
Add the zip files to Git.
(Problem: If a module is already installed, in the perl we are using, this will not download the zip file either)


