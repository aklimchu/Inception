FROM alpine:3.20.2

RUN apk update && apk upgrade && apk add --no-cache php82 php82-fpm \
php82-openssl php82-phar php82-mysqli php82-cli curl mysql-client \
php82-xml php82-mbstring && rm -rf /var/cache/apk/*

# Create php symlink if it doesn’t exist
RUN ln -sf /usr/bin/php82 /usr/bin/php

#Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
   && chmod +x wp-cli.phar \
   && mv wp-cli.phar /usr/local/bin/wp

RUN adduser -u 82 -G www-data -s /bin/sh -D www-data

RUN mkdir -p /var/www/html 

RUN chown -R www-data:www-data /var/www/html

RUN chmod -R 755 /var/www/html

COPY conf /etc/php82/php-fpm.d/www.conf

# Set PHP memory limit
RUN echo "memory_limit = 256M" > /etc/php82/conf.d/memory.ini

COPY /tools/php_script.sh .
RUN chmod +x php_script.sh

CMD ["sh", "/php_script.sh"]