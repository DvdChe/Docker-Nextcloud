FROM debian:jessie

RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' > /etc/apt/sources.list.d/pgsql.list && \
    gpg --keyserver keys.gnupg.net --recv-keys ACCC4CF8 && \
    gpg --export --armor ACCC4CF8|apt-key add -

RUN apt-get update 
RUN apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    nginx-full \
    php5-fpm php5-cli php5-pgsql php5-sqlite php5-gd php5-curl \
    postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 \
    && apt-get -y autoremove

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*


RUN ln -sf /proc/self/fd/1 /var/log/nginx/error.log && \
    ln -sf /proc/self/fd/1 /var/log/nginx/access.log

COPY files/default /etc/nginx/sites-available/default

COPY files/nextcloud /usr/nextcloud
COPY files/postgresql.conf /etc/postgresql/9.4/main/postgresql.conf 
COPY files/www.conf /etc/php5/fpm/pool.d/www.conf
COPY files/entrypoint.sh /entrypoint.sh
COPY files/php.ini /etc/php5/fpm/php.ini

VOLUME /var/www/html/apps
VOLUME /var/www/html/data
VOLUME /var/www/html/config
VOLUME /var/lib/postgresql/data

EXPOSE 80 443
ENTRYPOINT /entrypoint.sh
