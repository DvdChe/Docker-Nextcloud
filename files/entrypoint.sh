#!/bin/bash


if [ ! -f /var/www/html/version.php ]; then
    cp -arT /usr/nextcloud /var/www/html
fi

if [ ! -f /var/lib/postgresql/data/PG_VERSION ]; then
    cp -arT /var/lib/postgresql/9.4/main /var/lib/postgresql/data 
fi

chown -R www-data:www-data /var/www
chown -R postgres:postgres /var/lib/postgresql/data

/etc/init.d/php5-fpm start
/etc/init.d/nginx start
/etc/init.d/postgresql start


#.pg_user_is_created is a simple flag to check if db and user already exists

if [ ! -f /var/lib/postgresql/data/.pg_user_is_created ]; then

    su -m postgres -c "psql -c \"CREATE USER $PGSQL_USER WITH PASSWORD '$PGSQL_PASS';\""
    su -m postgres -c "psql -c \"CREATE DATABASE $PGSQL_USER;\""
    su -m postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE $PSQL_USER to $PSQL_USER;\""
    touch /var/lib/postgresql/data/.pg_user_is_created
fi



/bin/bash



