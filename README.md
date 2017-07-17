# Docker-Nextcloud
Just an image container nextcloud, running with Nginx, php5-fpm and PostgresSQL.
Everything is included and built to be ready to use... I hope....

Each components ( php, nginx, pgsql ) are installed with apt-get and downloaded from official Debian-Jessy repositories.

I made this image with keeping in mind that <strong>simple is beautiful</strong>.
No third party repositories or alternate software like gosu, and others are used.

This project is also an opportunity for me to experiment docker and play with it.

If you have advices or if you notice errors, please, let me know.

## Build imagze



```bash
git clone https://github.com/DvdChe/Docker-Nextcloud.git
```