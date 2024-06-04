FROM debian:10

EXPOSE 443

RUN apt-get update
RUN apt-get install -y apache2 git subversion libapache2-mod-php vim curl systemd libdate-manip-perl php-mbstring php-xml php-mysql php-intl php-gd libapache2-mod-python imagemagick

# Install and configure mail
RUN apt-get update && apt-get install -y exim4 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN sed -ie "s/^\(dc_eximconfig_configtype=\).*$/\1'smarthost'/" /etc/exim4/update-exim4.conf.conf && \
    sed -ie "s/^\(dc_smarthost=\).*$/\1'mail.cct.lsu.edu'/" /etc/exim4/update-exim4.conf.conf && \
    sed -ie "s/^\(dc_readhost=\).*$/\1'docs.einsteintoolkit.org'/" /etc/exim4/update-exim4.conf.conf && \
    sed -ie "s/^\(dc_hide_mailname=\).*$/\1'true'/" /etc/exim4/update-exim4.conf.conf && \
    sed -ie "s/^\(dc_other_hostnames=\).*$/\1'localhost'/" /etc/exim4/update-exim4.conf.conf && \
    update-exim4.conf

RUN rm -rf /var/www/html/index.html
#RUN rm -rf /var/www/html

WORKDIR /root
RUN mkdir -p /var/www/mediawiki
RUN curl -O "https://releases.wikimedia.org/mediawiki/1.31/mediawiki-1.31.0.tar.gz"
RUN tar -xf mediawiki-1.31.0.tar.gz --exclude="/images" --strip-components=1 -C /var/www/mediawiki
WORKDIR /var/www/mediawiki
COPY LocalSettings.php LocalSettings.php
COPY .htaccess .htaccess
# COPY LdapAuthentication-REL1_31-b19888c.tar.gz ./
# RUN tar -xf LdapAuthentication-REL1_31-b19888c.tar.gz
# Make sure that the www-data user ID matches the "apache/nobody/www-data" ID on the host
# 48 in this case (NON-PORTABLE!)
RUN usermod -u 48 www-data

# The user that apache2 uses to access the files is www-data
RUN find . -exec chown www-data '{}' \;

RUN a2enmod ssl rewrite speling python
RUN a2ensite default-ssl

RUN ln -s /var/log/apache2 /etc/apache2/logs

# If you wish to run without https support, just run the container.
# If you want https support, you should have the following files installed:
#   /etc/pki-etk/tls/private/einsteintoolkit.org.key
#   /etc/pki-etk/tls/certs/einsteintoolkit.org.crt
# docker run -d -v /etc/pki-etk:/etc/pki-etk --rm -p 443:443 -p 80:80 stevenrbrandt/etk-website

# docker run -d -v /etc/pki-etk:/etc/pki-etk --rm -P twwright_mediawiki
# docker run -d --rm -v /etc/pki-mediawiki:/etc/pki-mediawiki -v /var/mediawiki-uploads:/var/www/mediawiki/mediawiki-uploads --rm -p 11443:443 twwright_mediawiki
WORKDIR /etc/apache2/sites-available
COPY mediawiki.conf mediawiki.conf
RUN a2ensite mediawiki

# Get rid of apache's default that uses snakeoil certs
RUN rm -f /etc/apache2/sites-*/default-ssl.conf
RUN rm -f /etc/apache2/sites-*/000-default.conf

#RUN a2dissite default

WORKDIR /root

COPY startup.sh startup.sh

#CMD bash startup.sh
CMD sleep infinity
