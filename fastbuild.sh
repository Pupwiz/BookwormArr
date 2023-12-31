#!/bin/sh

DIR=$(pwd)
apt -qq install dos2unix
##make sure linux readable files - caused problems in past
echo "Making sure all files are Linux readabel"  
`find $(pwd)/custom_extras/cfg/ -type f -print0 | xargs -0 dos2unix -q --`
FILE=$DIR/local_packages/boxtools_1.05-amd64.deb
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "$FILE does not exist."
    echo "At a minimum boxtools is required"
    echo " Running boxtools build script"
    bash $DIR pkgboxtools.sh
fi
`find $(pwd)/templates/ -type f -print0 | xargs -0 dos2unix -q --`
echo "Starting ISO build with custom install files..!"  
build-simple-cdd --conf sda-atomic.conf --dvd --force-root 
 
echo " New iso created..!"

  
