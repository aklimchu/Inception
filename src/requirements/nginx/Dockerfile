FROM alpine:3.20.2

RUN apk update && apk upgrade && apk add --no-cache nginx openssl

# Create directories for certificates and web root
RUN mkdir -p /etc/nginx/certs /var/www/html

# Set ownership and permissions
RUN chown -R nginx:nginx /var/www/html && chmod -R 755 /var/www/html

# Copy configuration (assuming conf is a file named default.conf)
COPY conf /etc/nginx/http.d/default.conf

# Copy and make script executable
COPY tools/nginx_script.sh /nginx_script.sh
RUN chmod +x /nginx_script.sh

# Expose port 443 only
EXPOSE 443

CMD ["/bin/sh", "/nginx_script.sh"]