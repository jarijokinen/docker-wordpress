FROM debian:stable-slim

RUN apt-get update
RUN apt-get install --no-install-recommends --no-install-suggests -y \
  ca-certificates \
  nginx-light \
  php-fpm \
  php-mysql \
  tar \
  wget

RUN adduser --disabled-password --gecos '' wp
RUN mkdir /wp
RUN chown -R wp:wp /wp

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
COPY ./src/wp-config.php wordpress/wp-config.php

COPY ./src/init-wp.sh /init-wp.sh
RUN chmod 700 /init-wp.sh

COPY ./src/nginx.default.conf /etc/nginx/conf.d/default.conf
RUN sed -i 's/www-data/wp/g' /etc/php/8.2/fpm/pool.d/www.conf
RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' \
  /etc/php/8.2/fpm/pool.d/www.conf

ENV FOREGROUND=1
ENTRYPOINT ["/init-wp.sh"]
