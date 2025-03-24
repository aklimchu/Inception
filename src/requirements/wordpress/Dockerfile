FROM alpine:3.20.2

RUN apk update && apk upgrade && apk add php82-fpm

RUN adduser -u 82 -G www-data -s /bin/sh -D www-data

# will this erase any previous data?
RUN mkdir -p /var/www/html 

RUN chown -R www-data:www-data /var/www/html

RUN chmod -R 755 /var/www/html

COPY conf /etc/php82/php-fpm.d/www.conf

CMD ["php-fpm82", "-F"]