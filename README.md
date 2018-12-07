# et-websites
How to build the cactus &amp; et website
 
  docker build --no-cache -f etk-website.docker -t etk-website .
  
Running the website on your laptop without https

  docker run -p 8080:80 stevenrbrandt/etk-website
  
Doing the above will allow you to access the website on localhost:8080 on your own computer.
If you want https, you need to find a key and a crt file.

  docker run -d -v /etc/pki-etk:/etc/pki-etk --rm -p 443:443 -p 80:80 stevenrbrandt/etk-website

Where the following files must exist

  /etc/pki-etk/tls/private/einsteintoolkit.org.key
  /etc/pki-etk/tls/certs/einsteintoolkit.org.crt

For the wiki, things work similarly. However, the wiki needs to connect to an external
database currently maintained by CCT staff.

  docker run -d --rm -v /var/mediawiki-uploads:/var/www/mediawiki/mediawiki-uploads \
     -v /etc/pki-mediawiki:/etc/pki-mediawiki -p 11443:443 twwright_mediawiki
     
The following files need to exist.

  /etc/pki-mediawiki/tls/certs/docs.einsteintoolkit.org.cer
  /etc/pki-mediawiki/tls/private/docs.einsteintoolkit.org.key

A Cactuscode.org build in Docker was also constructed, but has not been installed.
