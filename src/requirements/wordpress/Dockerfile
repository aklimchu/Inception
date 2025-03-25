FROM alpine:3.20.2

RUN apk update && apk upgrade && apk add php82-fpm php-mysqli curl

RUN adduser -u 82 -G www-data -s /bin/sh -D www-data

RUN mkdir -p /var/www/html 

RUN chown -R www-data:www-data /var/www/html

RUN chmod -R 755 /var/www/html

COPY conf /etc/php82/php-fpm.d/www.conf

COPY /tools/php_script.sh .
RUN chmod +x php_script.sh

CMD ["sh", "/php_script.sh"]