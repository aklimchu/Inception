FROM alpine:3.20.2

RUN apk update && apk upgrade && apk add php82-fpm

CMD ["php-fpm82", "-F"]