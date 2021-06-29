FROM debian:9.7

EXPOSE 443

RUN apt-get update
RUN apt-get install -y apache2 git subversion libapache2-mod-php vim curl systemd ssmtp libdate-manip-perl php7.0-mbstring php7.0-xml php7.0-mysql php7.0-intl php7.0-gd libapache2-mod-python imagemagick

# Configure mail
RUN sed -ie "s/\(mailhub=\).*$/\1mail.cct.lsu.edu/" /etc/ssmtp/ssmtp.conf
RUN sed -ie "s/\(hostname=\).*$/\1einsteintoolkit.org/" /etc/ssmtp/ssmtp.conf
RUN sed -ie "s/.FromLineOverride=YES/FromLineOverride=YES/" /etc/ssmtp/ssmtp.conf

#  Configuration for Apache2
RUN sed -ie "s/;\(sendmail_path =\).*$/\1 \/usr\/sbin\/ssmtp -t/" /etc/php/7.0/apache2/php.ini

#  Configuration for CLI
RUN sed -ie "s/;\(sendmail_path =\).*$/\1 \/usr\/sbin\/ssmtp -t/" /etc/php/7.0/cli/php.ini

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

#RUN a2dissite default

WORKDIR /root

COPY startup.sh startup.sh

#CMD bash startup.sh
CMD sleep infinity
