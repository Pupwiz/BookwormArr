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

cd $(pwd)/images

while IFS= read -r file;
do 
DEB="$file"
done< <(find . -name '*.iso')
  mkdir isofiles
  bsdtar -C isofiles -xf "$DEB"
  tmp_isolinux_cfg=$(mktemp --tmpdir isolinux.XXXXX)
#  sed 's/timeout 0/timeout 3/g' isofiles/isolinux/isolinux.cfg >$tmp_isolinux_cfg
  echo "default install" >>$tmp_isolinux_cfg
  chmod +w isofiles/isolinux/isolinux.cfg
  cat $tmp_isolinux_cfg >isofiles/isolinux/isolinux.cfg
  chmod -w isofiles/isolinux/isolinux.cfg
  rm $tmp_isolinux_cfg
  chmod +w isofiles/boot/grub/grub.cfg
  echo 'set default="2>1"' >>isofiles/boot/grub/grub.cfg
  echo "set timeout=10" >>isofiles/boot/grub/grub.cfg
  chmod -w isofiles/boot/grub/grub.cfg
  cd isofiles
  chmod +w md5sum.txt
  find . -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum >md5sum.txt
  chmod -w md5sum.txt
  cd ..
  orig_iso="$DEB"
  new_iso="preseed-debian-12-amd64-DVD-1.iso"
  dd if="$orig_iso" bs=1 count=432 of=mbr_template.bin
  chmod +w isofiles/isolinux/isolinux.bin
  xorriso -as mkisofs -r \
    -V 'Debian AUTO amd64' \
    -o "$new_iso" \
    -J -joliet-long \
    -cache-inodes \
    -isohybrid-mbr mbr_template.bin \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -boot-load-size 4 -boot-info-table \
    -no-emul-boot -eltorito-alt-boot \
    -e boot/grub/efi.img -no-emul-boot \
    -isohybrid-gpt-basdat \
    -isohybrid-apm-hfsplus \
    isofiles
  chmod +w isofiles -R
  rm -rf isofiles mbr_template.bin
  rm $DEB
  rm *.gz
  mv $new_iso ../
cd $(pwd)
echo " New iso created $new_iso in $(pwd)...!"

  
