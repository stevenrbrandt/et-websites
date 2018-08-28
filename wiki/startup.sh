#!/bin/bash
cd /root
# Detect if the key is there...
if [ -r /etc/pki-etk/tls/private/einsteintoolkit.org.key ]
then
    # If it is, enable ssl
    cp etk-ssl.conf /etc/apache2/conf-enabled/
fi
/usr/sbin/apache2ctl -D FOREGROUND
