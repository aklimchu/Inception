#!/bin/bash

# Check if required environment variables are set
if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_NAME" ] || \
  [ -z "$WORDPRESS_DB_NAME" ] || [ -z "$WORDPRESS_DB_HOST" ] || [ -z "$WORDPRESS_DB_USER" ] || \
  [ -z "$WORDPRESS_DB_PASSWORD" ] || [ -z "$WORDPRESS_TITLE" ] || [ -z "$WORDPRESS_ADMIN_NAME" ] || \
  [ -z "$WORDPRESS_ADMIN_PASS" ] || [ -z "$WORDPRESS_USER_NAME" ] || [ -z "$WORDPRESS_USER_PASS" ]; then
  echo "Error: one of required environmental variables is not set not set."
  exit 1
fi

cd /var/www/html

echo "Cleaning up /var/www/html..."
rm -rf /var/www/html/* || { echo "Failed to clean /var/www/html"; exit 1; }

echo "Waiting for MariaDB to be ready..."
attempts=0
max_attempts=20
until mysqladmin ping -h $MYSQL_NAME -u $MYSQL_USER -p$MYSQL_PASSWORD --silent; do
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
mysql -h $MYSQL_NAME -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" || { echo "MySQL connection failed"; exit 1; }

# WordPress setup with increased memory limit
if [ ! -f "wp-config.php" ]; then
  php82 -d memory_limit=256M /usr/local/bin/wp core download --allow-root || { echo "Failed to download WordPress"; exit 1; }
  php82 -d memory_limit=256M /usr/local/bin/wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER \
    --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root || { echo "Failed to create wp-config.php"; exit 1; }
  php82 -d memory_limit=256M /usr/local/bin/wp core install --url=https://$DOMAIN_NAME --title="$WORDPRESS_TITLE" \
      --admin_user=$WORDPRESS_ADMIN_NAME --admin_password=$WORDPRESS_ADMIN_PASS --admin_email=$WORDPRESS_ADMIN_NAME@example.com \
      --allow-root || { echo "Failed to install WordPress"; exit 1; }

  # Add a second user only if it doesn't exist
  if ! php82 -d memory_limit=256M /usr/local/bin/wp user get $WORDPRESS_USER_NAME --path=/var/www/html --allow-root >/dev/null 2>&1; then
    php82 -d memory_limit=256M /usr/local/bin/wp user create $WORDPRESS_USER_NAME wpuser@example.com --role=editor \
      --user_pass=$WORDPRESS_USER_PASS --path=/var/www/html --allow-root || { echo "Failed to create second user"; exit 1; }
  else
    echo "User $WORDPRESS_USER_NAME already exists, skipping creation..."
  fi
else
  echo "WordPress already installed, skipping setup..."
fi

# Verify users
echo "Listing WordPress users..."
php82 -d memory_limit=256M /usr/local/bin/wp user list --path=/var/www/html --allow-root

php-fpm82 -F