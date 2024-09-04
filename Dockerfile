FROM nginx:latest

RUN apt-get update
RUN apt-get install -y php-fpm php-mysql tar wget

RUN adduser --disabled-password --gecos '' wp
RUN mkdir /wp
RUN chown -R wp:wp /wp

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
COPY ./conf/wp-config.php wordpress/wp-config.php

COPY ./init-wp.sh /init-wp.sh
RUN chmod 700 /init-wp.sh

COPY ./conf/nginx.default.conf /etc/nginx/conf.d/default.conf
RUN sed -i 's/www-data/wp/g' /etc/php/8.2/fpm/pool.d/www.conf
RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' \
  /etc/php/8.2/fpm/pool.d/www.conf
RUN echo 'clear_env = no' >> /etc/php/8.2/fpm/pool.d/www.conf

EXPOSE 80
ENTRYPOINT ["/init-wp.sh"]
