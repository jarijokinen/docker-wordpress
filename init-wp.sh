#!/bin/bash

set -e

if [[ ! -f /wp/wp-config.php ]]; then
  cp -r /wordpress/* /wp/

  export SALTS=$(wget -q https://api.wordpress.org/secret-key/1.1/salt/ -O -)

  perl -i -pe 's/%WORDPRESS_ENV%/$ENV{"WORDPRESS_ENV"}/g' /wp/wp-config.php
  perl -i -pe 's/%WORDPRESS_DB_NAME%/$ENV{"WORDPRESS_DB_NAME"}/g' /wp/wp-config.php
  perl -i -pe 's/%WORDPRESS_DB_USER%/$ENV{"WORDPRESS_DB_USER"}/g' /wp/wp-config.php
  perl -i -pe 's/%WORDPRESS_DB_PASSWORD%/$ENV{"WORDPRESS_DB_PASSWORD"}/g' /wp/wp-config.php
  perl -i -pe 's/%WORDPRESS_DB_HOST%/$ENV{"WORDPRESS_DB_HOST"}/g' /wp/wp-config.php
  perl -i -pe 's/%WORDPRESS_SALTS%/$ENV{"SALTS"}/g' /wp/wp-config.php

  chown -R wp:wp /wp
fi

/etc/init.d/php8.2-fpm start && nginx -g 'daemon off;'

exit 0
