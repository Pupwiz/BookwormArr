#!/bin/bash
cat <<EOF >> /etc/php/8.2/cli/php.ini
zend_extension=opcache
opcache.enable=1
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000    
opcache.memory_consumption=128
opcache.save_comments=1
opcache.revalidate_freq=1
apc.enable_cli=1
EOF
sudo -u www-data php /var/www/html/nextcloud/occ config:system:set default_phone_region --value="CA"
sudo -u www-data php /var/www/html/nextcloud/occ config:system:set memcache.local --value="\\OC\\Memcache\\APCu"
sudo -u www-data php /var/www/html/nextcloud/occ app:install documentserver_community
sudo -u www-data php /var/www/html/nextcloud/occ app:install onlyoffice
exit 1

