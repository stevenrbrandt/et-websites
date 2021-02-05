#!/bin/bash
cd /root
chsh www-data --shell /bin/bash
su -l www-data -c /var/www/einstein/update
chsh www-data --shell /bin/false
# Detect if the key is there...
if [ -r /etc/pki-etk/tls/private/einsteintoolkit.org.key ]
then
    # If it is, enable ssl
    cp etk-ssl.conf /etc/apache2/conf-enabled/
fi
/etc/init.d/exim4 start
/usr/sbin/apache2ctl -D FOREGROUND
