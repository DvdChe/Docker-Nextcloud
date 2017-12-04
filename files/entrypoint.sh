#!/bin/bash

if [ ! -f /var/lib/mysql_data/.flag ]; then

    rm -rf /var/www/html/*
    cp -arTv /usr/nextcloud /var/www/html
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

/etc/init.d/mysql start
/etc/init.d/apache2 start

/bin/bash
