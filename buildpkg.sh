#!/bin/bash
## builds all deb packages for iso installer updated to time of script running 
## using develop for all ARR versions. You can change to nightly after install in the apps settings.
echo "Checking for required debian packages..! "  | wall -n
apt -y -qq install cmake zlib1g-dev build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libgtk-3-dev 
DIR=$(pwd)
bash $DIR/pkgsonarr.sh
bash $DIR/pkgprowlarr.sh
bash $DIR/pkgradarr.sh
#bash $DIR/pkgreadarr.sh
#bash $DIR/pkglidarr.sh
bash $DIR/pkgboxtools.sh
bash $DIR/pkgemby.sh
bash $DIR/pkgunpackerr.sh
bash $DIR/pkgflaresolverr.sh
rm $DIR/tmp -r
echo "All debian packages updated now runing bash fastbuild for you to create new ISO..! "  | wall -n
bash $DIR/fastbuild
