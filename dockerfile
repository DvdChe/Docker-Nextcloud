FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    bzip2 \
    apache2 \
    php7.0 php7.0-cli php7.0-mysql php7.0-sqlite php7.0-gd php7.0-curl php7.0-gd php7.0-mcrypt php7.0-zip php7.0-xml php7.0-mbstring \
    mysql-server \
    && apt-get -y autoremove

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*

COPY files/nextcloud /nextcloud
COPY files/entrypoint.sh /entrypoint.sh

RUN { \
  echo 'opcache.enable=1'; \
  echo 'opcache.enable_cli=1'; \
  echo 'opcache.interned_strings_buffer=8'; \
  echo 'opcache.max_accelerated_files=10000'; \
  echo 'opcache.memory_consumption=128'; \
  echo 'opcache.save_comments=1'; \
  echo 'opcache.revalidate_freq=1'; \
} > /etc/php/7.0/apache2/conf.d/opcache-recommended.ini

RUN sed -i 's/datadir.*/datadir = \/var\/lib\/mysql_data/g' /etc/mysql/mariadb.conf.d/50-server.cnf 
RUN rm -v /etc/apache2/sites-available/*.conf /etc/apache2/sites-enabled/*

RUN { \
  echo '<VirtualHost *:80>'; \
  echo '    DocumentRoot "/var/www/nextcloud/"'; \
  echo '    <Directory /var/www/nextcloud/>'; \
  echo '      Options +FollowSymlinks -Indexes'; \
  echo '      AllowOverride All'; \
  echo '     <IfModule mod_dav.c>'; \
  echo '      Dav Off'; \
  echo '     </IfModule>'; \
  echo '     SetEnv HOME /var/www/nextcloud'; \
  echo '     SetEnv HTTP_HOME /var/www/nextcloud'; \
  echo '    </Directory>'; \
  echo '</VirtualHost>'; \
} > /etc/apache2/sites-available/nextcloud.conf

RUN { \
   echo 'ServerSignature Off'; \
   echo 'ServerTokens Prod'; \
} >> /etc/apache2/apache2.conf


   

VOLUME /var/www/nextcloud/apps
VOLUME /var/www/nextcloud/data
VOLUME /var/www/nextcloud/config
VOLUME /var/lib/mysql_data

EXPOSE 80 443
ENTRYPOINT /entrypoint.sh
