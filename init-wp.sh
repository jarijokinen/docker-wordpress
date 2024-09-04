#!/bin/bash

set -e

if [[ ! -f /wp/wp-config.php ]]; then
  cp -r /wordpress/* /wp/
  chown -R wp:wp /wp
fi

/etc/init.d/php8.2-fpm start && nginx -g 'daemon off;'

exit 0
