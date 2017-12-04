FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    apache2 \
    php7.0-fpm php7.0-cli php7.0-mysql php7.0-sqlite php7.0-gd php7.0-curl php7.0-gd php7.0-mcrypt \
    mysql-server \
    && apt-get -y autoremove

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*


COPY files/nextcloud /usr/nextcloud
COPY files/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY files/entrypoint.sh /entrypoint.sh

VOLUME /var/www/html/apps
VOLUME /var/www/html/data
VOLUME /var/www/html/config
VOLUME /var/lib/mysql_data

EXPOSE 80 443
ENTRYPOINT /entrypoint.sh
