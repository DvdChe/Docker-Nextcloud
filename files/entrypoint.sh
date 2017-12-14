#!/bin/bash

/etc/init.d/apache2 stop
cp -arTv /nextcloud /var/www/nextcloud
chown -R www-data: /var/www

if [ ! -f /var/lib/mysql_data/.flag ]; then

    chown -R www-data: /var/www

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
rm /etc/apache2/sites-enabled/000-default.conf
ln -s /etc/apache2/sites-available/nextcloud.conf /etc/apache2/sites-enabled/nextcloud.conf

a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dire
a2enmod mime

/etc/init.d/mysql start
/etc/init.d/apache2 start

/bin/bash
