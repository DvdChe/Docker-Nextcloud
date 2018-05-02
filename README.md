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

```bash
docker-compose build
```

```bash
docker-compose up -d
```
