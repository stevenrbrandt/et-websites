#!/bin/bash
# Detect if the key is there...
cd /var/www/einstein/live
svn update
cd /var/www/einstein/live/manifest
git pull
cd /var/www/einstein/www
git pull
cd /var/www/einstein/seminars
git pull
cd /var/www/einstein/testsuite_results
git pull
if [ -r /etc/pki-etk/tls/private/einsteintoolkit.org.key ]
then
    # If it is, enable ssl
    cp etk-ssl.conf /etc/apache2/conf-enabled/
fi
/usr/sbin/apache2ctl -D FOREGROUND
