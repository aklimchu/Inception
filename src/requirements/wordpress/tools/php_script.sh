#!/bin/bash

cd /var/www/html

echo "Cleaning up /var/www/html..."
rm -rf /var/www/html/* || { echo "Failed to clean /var/www/html"; exit 1; }

echo "Waiting for MariaDB to be ready..."
attempts=0
max_attempts=20
until mysqladmin ping -h mariadb -u root -ppassword1234 --silent; do
    echo "Still waiting for MariaDB... (Attempt $((attempts + 1))/$max_attempts)"
    sleep 3
    attempts=$((attempts + 1))
    if [ $attempts -ge $max_attempts ]; then
        echo "MariaDB not ready after $max_attempts attempts, exiting..."
        exit 1
    fi
done
echo "MariaDB is ready!"

# Debug: Test MySQL connection
echo "Testing MySQL connection..."
mysql -h mariadb -u root -ppassword1234 -e "SHOW DATABASES;" || { echo "MySQL connection failed"; exit 1; }

# WordPress setup with increased memory limit
if [ ! -f "wp-config.php" ]; then
  php82 -d memory_limit=256M /usr/local/bin/wp core download --allow-root || { echo "Failed to download WordPress"; exit 1; }
  php82 -d memory_limit=256M /usr/local/bin/wp config create --dbname=wordpress --dbuser=root --dbpass=password1234 --dbhost=mariadb --allow-root || { echo "Failed to create wp-config.php"; exit 1; }
  php82 -d memory_limit=256M /usr/local/bin/wp core install --url=https://aklimchu.42.fr --title="Inception" \
      --admin_user=supervisor --admin_password=superpass --admin_email=supervisor@example.com --allow-root || { echo "Failed to install WordPress"; exit 1; }

  # Add a second user (wp_user) only if it doesn't exist
  if ! php82 -d memory_limit=256M /usr/local/bin/wp user get wp_user --path=/var/www/html --allow-root >/dev/null 2>&1; then
    php82 -d memory_limit=256M /usr/local/bin/wp user create wp_user wpuser@example.com --role=editor --user_pass=wpuserpass --path=/var/www/html --allow-root || { echo "Failed to create second user"; exit 1; }
  else
    echo "User wp_user already exists, skipping creation..."
  fi
else
  echo "WordPress already installed, skipping setup..."
fi

# Verify users
echo "Listing WordPress users..."
php82 -d memory_limit=256M /usr/local/bin/wp user list --path=/var/www/html --allow-root

php-fpm82 -F