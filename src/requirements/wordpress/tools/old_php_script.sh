#!/bin/bash

# Wait for MariaDB to be ready
#until mysql -h mariadb -u root -prootpassword -e "SELECT 1"; do
#    echo "Waiting for database to be ready..."
#    sleep 3
#done

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h mariadb -u root -proot_password --silent; do
    echo "Still waiting for MariaDB..."
    sleep 3
done

echo "MariaDB is ready!"

# Download WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Make it executable and move it to a system-wide location
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Download WordPress
wp core download --path=/var/www/html --allow-root

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