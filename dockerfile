FROM debian:stretch-slim
ENV DEBIAN_FRONTEND=noninteractive

LABEL maintainer="dch@co-lide.net"

RUN apt-get update 
RUN apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    bzip2 \
    rsync \
    cron \
    apache2 \
    php7.0 php7.0-cli php7.0-mysql php7.0-sqlite php7.0-gd php7.0-curl php7.0-gd php7.0-mcrypt php7.0-zip php7.0-xml php7.0-mbstring \
    mysql-server \
    && apt-get -y autoremove

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*

COPY files/nextcloud /nextcloud
COPY files/entrypoint.sh /entrypoint.sh

RUN chown -R www-data: /nextcloud

RUN rm -v /etc/apache2/sites-available/*.conf /etc/apache2/sites-enabled/*

VOLUME /var/www/nextcloud/apps
VOLUME /var/www/nextcloud/data
VOLUME /var/www/nextcloud/config
VOLUME /var/lib/mysql_data

EXPOSE 80 443
ENTRYPOINT /entrypoint.sh
