#!/bin/bash


/etc/init.d/apache2 stop

rsync -rlDog /nextcloud/ /var/www/nextcloud/
chown -R www-data: /var/www

{ \
  echo 'opcache.enable=1'; \
  echo 'opcache.enable_cli=1'; \
  echo 'opcache.interned_strings_buffer=8'; \
  echo 'opcache.max_accelerated_files=10000'; \
  echo 'opcache.memory_consumption=128'; \
  echo 'opcache.save_comments=1'; \
  echo 'opcache.revalidate_freq=1'; \
} > /etc/php/7.0/apache2/conf.d/opcache-recommended.ini

sed -i 's/datadir.*/datadir = \/var\/lib\/mysql_data/g' /etc/mysql/mariadb.conf.d/50-server.cnf

{ \
   echo 'innodb_buffer_pool_size = 1073741824' ; \
} >> /etc/mysql/mariadb.conf.d/50-server.cnf

{ \
  echo 'ServerName ${NC_FQDN}'; \
  echo '<VirtualHost *:80>'; \
  echo '    SetEnvIf X-Forwarded-For "^.*\..*\..*\..*" forwarded'; \
  echo '    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined'; \
  echo '    LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" forwarded'; \
  echo '    ErrorLog ${APACHE_LOG_DIR}/error.log'; \
  echo '    CustomLog ${APACHE_LOG_DIR}/access.log combined env=!forwarded'; \
  echo '    CustomLog ${APACHE_LOG_DIR}/access.log forwarded env=forwarded'; \
  echo '    ErrorLog ${APACHE_LOG_DIR}/nextcloud-error.log'; \
  echo '    CustomLog ${APACHE_LOG_DIR}/nextcloud-access.log combined'; \
  echo '    DocumentRoot /var/www/nextcloud/'; \
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

ncpu=$(cat /proc/cpuinfo | grep processor | wc -l)
dbncpu=$(($ncpu * 2))
dbncput=$(($ncpu * 2 + 10))

{ \
  echo "<IfModule mpm_prefork_module>"; \
  echo "    StartServers          ${dbncpu}"; \
  echo "    MinSpareServers       ${dbncpu}"; \
  echo "    MaxSpareServers       ${dbncpu}"; \
  echo "    MaxClients            ${dbncput}"; \
  echo "    MaxRequestsPerChild   1000"; \
  echo "</IfModule>"; \
} > /etc/apache2/mods-available/mpm_prefork.conf

{ \
   echo 'ServerSignature Off'; \
   echo 'ServerTokens Prod'; \
} >> /etc/apache2/apache2.conf

if [ ! -f /var/lib/mysql_data/.flag ]; then

    cp -Rv /var/lib/mysql/* /var/lib/mysql_data
    echo "set ownership of /var/lib/mysql_data"

    chown -R mysql: /var/lib/mysql_data

    /etc/init.d/mysql start

    mysql -u root -e "CREATE DATABASE ${DB_NAME};"
    mysql -u root -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"

    touch /var/lib/mysql_data/.flag


fi

rm -rf /var/www/html
ln -s /etc/apache2/sites-available/nextcloud.conf /etc/apache2/sites-enabled/nextcloud.conf

usermod www-data -s /bin/bash
su www-data -c -- '(crontab -l 2>/dev/null; echo "*/15 * * * * /usr/bin/php -f /var/www/nextcloud/cron.php") | crontab -'

a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod mime

/etc/init.d/mysql start
/etc/init.d/cron start
source /etc/apache2/envvars

exec apache2 -DFOREGROUND

