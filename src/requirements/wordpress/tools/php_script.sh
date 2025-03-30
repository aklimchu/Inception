#!/bin/bash

echo "PHP version:"
php82 --version
echo "WP-CLI version:"
php82 /usr/local/bin/wp --info

cd /var/www/html

echo "Cleaning up /var/www/html..."
rm -rf /var/www/html/* || { echo "Failed to clean /var/www/html"; exit 1; }

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h mariadb -u root -prootpass --silent; do
    echo "Still waiting for MariaDB..."
    sleep 3
done
echo "MariaDB is ready!"

# Debug: Test MySQL connection
echo "Testing MySQL connection..."
mysql -h mariadb -u root -prootpass -e "SHOW DATABASES;" || { echo "MySQL connection failed"; exit 1; }

# WordPress setup with increased memory limit
php82 -d memory_limit=256M /usr/local/bin/wp core download --allow-root || { echo "Failed to download WordPress"; exit 1; }
php82 -d memory_limit=256M /usr/local/bin/wp config create --dbname=wordpress --dbuser=root --dbpass=rootpass --dbhost=mariadb --allow-root || { echo "Failed to create wp-config.php"; exit 1; }
php82 -d memory_limit=256M /usr/local/bin/wp core install --url=localhost --title="Inception" \
    --admin_user=supervisor --admin_password=superpass --admin_email=supervisor@example.com --allow-root || { echo "Failed to install WordPress"; exit 1; }

# Add a second user (wp_user)
php82 -d memory_limit=256M /usr/local/bin/wp user create wp_user wpuser@example.com --role=editor --user_pass=wpuserpass --path=/var/www/html --allow-root || { echo "Failed to create second user"; exit 1; }

# Verify users
echo "Listing WordPress users..."
php82 -d memory_limit=256M /usr/local/bin/wp user list --path=/var/www/html --allow-root

php-fpm82 -F