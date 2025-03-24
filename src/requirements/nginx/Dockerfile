FROM alpine:3.20.2

RUN apk update && apk upgrade && apk add nginx && apk add openssl && \
    openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt \
    -sha256 -days 365 -nodes -subj \
    "/C=FI/L=HEL/O=Hive/OU=Student/CN=aklimchu.42.fr/"

CMD ["nginx", "-g", "daemon off;"]