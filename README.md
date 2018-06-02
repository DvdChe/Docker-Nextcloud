# Docker-Nextcloud
Just a nextcloud container , running with Apache, php7 and MariaDB.
Everything is included and built to be ready to use... I hope....

Each components are installed with apt-get and downloaded from official Debian Repositories.

No third party repositories or alternate software like gosu, and othersi stuff are used.
This project is also an opportunity for me to experiment docker and play with it.
If you have advices or if you notice any errors, bad practice, please, let me know.

## Build image

```bash
git clone https://github.com/DvdChe/Docker-Nextcloud.git
```

Get the last version of Nextcloud. unwip it at the location files/
This where the dockerfile will copy the nextcloud application into image :
```
COPY files/nextcloud /nextcloud
```

Then you can build the image with docker-compose :

```bash
docker-compose build
```

```bash
docker-compose up -d
```

Here is the stuff to persist :

```yaml
volumes:
    - directory/nextcloud/apps:/var/www/nextcloud/apps/
    - directory/nextcloud/config:/var/www/nextcloud/config/
    - directory/nextcloud/data:/var/www/nextcloud/data/
    - directory/database:/var/lib/mysql_data/
```

# Entrypoint

When container is started, entrypoint.sh will set mpm_prefork configuration 
