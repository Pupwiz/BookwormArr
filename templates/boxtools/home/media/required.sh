#!/bin/bash
systemctl enable emby-server
systemctl stop transmission-daemon
systemctl stop sonarr
systemctl stop radarr
systemctl stop readarr
systemctl stop lidarr
systemctl stop prowlarr
sudo usermod -a -G media emby
sudo usermod -a -G emby media
{
    sleep 0.5
    echo -e "XXX\n0\napt -qq install -y nodejs... \nXXX"
    sleep 2
     echo -e "XXX\n25\ninstalled nodejs... Done.\nXXX"
    sleep 0.5

    echo -e "XXX\n25\npip install bottle --break-system-packages... \nXXX"
    sleep 2
    echo -e "XXX\n50\ninstall bottle ... Done.\nXXX"
    sleep 0.5

    echo -e "XXX\n50\npip install swig --break-system-packages... \nXXX"
    sleep 2
    echo -e "XXX\n75\ninstall swig ... Done.\nXXX"
    sleep 0.5

    echo -e "XXX\n75\npip install -r /opt/mp4auto/setup/requirements.txt --break-system-packages... \nXXX"
    sleep 2
    echo -e "XXX\n100\nmp4auto requirements... Done.\nXXX"
    sleep 1
} |whiptail --title "Install Custom Extras" --gauge "Please wait while installing" 6 60 0
#apt -qq install -y nodejs || exit 1
#pip install bottle --break-system-packages || exit 1
#pip install swig --break-system-packages || exit 1
#pip install -r /opt/mp4auto/setup/requirements.txt --break-system-packages || exit 1
chown media: -R /opt/mp4auto || exit 1
{
    sleep 0.5
    echo -e "XXX\n0\nsudo -H -E npm install cloudcmd -g... \nXXX"
    sleep 2
     echo -e "XXX\n25\nCloudcmd install... Done.\nXXX"
    sleep 0.5

    echo -e "XXX\n25\nsudo -H -E npm install gritty -g... \nXXX"
    sleep 2
    echo -e "XXX\n50\ninstall gritty... Done.\nXXX"
    } |whiptail --title "Install Cloudcmd with Gritty" --gauge "Please wait while installing" 6 60 0
#echo "Installing Cloudcmd with Gritty..!"  | wall -n
#sudo -H -E npm config set user 0
#sudo -H -E npm config set unsafe-perm true
#sudo -H -E npm install cloudcmd -g
#sudo -H -E npm install gritty -g
cat >"/etc/systemd/system/cloudcmd.service" <<SER
[Unit]
        Description=Cloud Commander
        [Service]
        TimeoutStartSec=0
        Restart=always
        User=root
        WorkingDirectory=/home/media
        ExecStart=/usr/bin/cloudcmd
        [Install]
        WantedBy=multi-user.target
SER
echo "Starting Cloudcmd..!"  | wall -n
# Reload systemd daemon
systemctl daemon-reload
# Enable the service for following restarts
systemctl enable cloudcmd.service
# Run the service
systemctl start cloudcmd.service
/bin/bash /home/media/update_arr.database || exit 1
#echo "Updating database Arr programs completed..!"  | wall -n
echo "System will reboot one last time for final updates install..!"  | wall -n
echo "Updates and software not required to make the system run will "  | wall -n
echo "now be removed please wait for the reboot. Dont force the system off..!"  | wall -n
sudo apt -qq upgrade -y
DEBIAN_FRONTEND=noninteractive apt-get -qq remove debian-faq debian-faq-de debian-faq-fr debian-faq-it debian-faq-zh-cn  doc-debian foomatic-filters hplip iamerican ibritish ispell vim-common vim-tiny reportbug
sudo apt -qq tailscale -y
sudo apt -qq autoremove -y
echo "Cleanup done adding tailscale for remote assitance..!"  | wall -n
rm /etc/issue
cat > /etc/issue << EOF
Hostname \n
Date: \d
IP4 address: \4
Login User: \U
\t
Welcome!
EOF
export MYPWD="mediabox";
export NEWPWD="nextmedia";
sudo mysql_secure_installation 2>/dev/null <<MSI
n
y
${MYPWD}
${MYPWD}
y
y
y
y
MSI
mysql --user="root" --execute="CREATE DATABASE nextcloud;"
mysql --user="root" --execute="CREATE USER nextcloud@localhost IDENTIFIED BY 'mediabox';"
mysql --user="root" --execute="GRANT ALL PRIVILEGES ON nextcloud.* TO nextcloud@localhost;"
mysql --user="root" --execute="FLUSH PRIVILEGES;"
##Set Local IP for Organizer to find links
IFACE=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')
NETIP=$(ip a s $IFACE | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2)
cat > /tmp/org.sql << ORG
 UPDATE tabs SET url = REPLACE(url,'http://127.0.0.1', 'http://$NETIP');
 UPDATE tabs SET url_local = REPLACE(url_local,'http://127.0.0.1', 'http://$NETIP');
ORG
cat /tmp/org.sql | sqlite3 /var/www/html/data/orgdb.db
rm /tmp/org.sql
rm /etc/systemd/system/getty@.service.d/override.conf
rm -- "$0"
echo "Rebooting Thanks for your patience..!"  | wall -n
init 6
exit 0
