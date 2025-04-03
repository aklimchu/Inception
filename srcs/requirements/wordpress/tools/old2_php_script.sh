#!/bin/bash

# Debug: Check PHP and WP-CLI
echo "PHP version:"
php82 --version
echo "WP-CLI version:"
wp --info

cd /var/www/html

# Clean existing WordPress files
echo "Cleaning up /var/www/html..."
rm -rf /var/www/html/* || { echo "Failed to clean /var/www/html"; exit 1; }

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h mariadb -u wpuser -ppassword --silent; do
    echo "Still waiting for MariaDB..."
    sleep 3
done
echo "MariaDB is ready!"

# Debug: Test MySQL connection
echo "Testing MySQL connection..."
mysql -h mariadb -u wpuser -ppassword -e "SHOW DATABASES;" || { echo "MySQL connection failed"; exit 1; }

#curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#chmod +x wp-cli.phar

#./wp-cli.phar core download --allow-root
#./wp-cli.phar config create --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root
#./wp-cli.phar core install --url=localhost --title=inception --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root

php82 -d memory_limit=256M /usr/local/bin/wp core download --allow-root || { echo "Failed to download WordPress"; exit 1; }
php82 -d memory_limit=256M /usr/local/bin/wp config create --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root || { echo "Failed to create wp-config.php"; exit 1; }
php82 -d memory_limit=256M /usr/local/bin/wp core install --url=localhost --title="Inception" \
    --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root || { echo "Failed to install WordPress"; exit 1; }

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

php-fpm82 -F