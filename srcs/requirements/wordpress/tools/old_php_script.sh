#!/bin/bash

# Wait for MariaDB to be ready
until mysql -h mariadb -u root -prootpassword -e "SELECT 1"; do
    echo "Waiting for database to be ready..."
    sleep 3
done

# Download WordPress
wp core download --path=/var/www/html

# Configure WordPress wp-config.php
wp config create --path=/var/www/html --dbname=wordpress --dbuser=wp_user --dbpass=password --dbhost=mariadb --allow-root

# Install WordPress
wp core install --path=/var/www/html --url=localhost --title="Inception" \
    --admin_user=supervisor --admin_password=password --admin_email=supervisor@example.com --allow-root

# Set appropriate permissions for the WordPress files
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start PHP-FPM
php-fpm82 -F