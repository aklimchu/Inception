#!/bin/bash

# Check if database is already initialized
if [ -d "/var/lib/mysql/mysql" ]; then
  echo "Database already initialized, skipping mysql_install_db..."
else
  echo "Initializing database..."
  mysql_install_db --user=root --datadir=/var/lib/mysql || {
    echo "Failed to initialize database"
    exit 1
  }
fi

# Start MariaDB temporarily in the background
echo "Starting MariaDB in background..."
mysqld --user=root --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock --pid-file=/run/mysqld/mysqld.pid &

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to start..."
until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; do
  echo "MariaDB not ready yet..."
  sleep 1
done
echo "MariaDB is ready!"

# Apply init.sql only if wordpress database doesn't exist
echo "Checking if init.sql needs to be applied..."
if [ -d "/var/lib/mysql/mysql" ]; then
  # Use root@% explicitly with password1234 over TCP
  if mysql -h mariadb -u root -ppassword1234 -e "SHOW DATABASES;" | grep -q "wordpress"; then
    echo "wordpress database already exists, skipping init.sql..."
  else
    echo "Applying init.sql..."
    mysql --socket=/run/mysqld/mysqld.sock -u root < /etc/my.cnf.d/init.sql || {
      echo "Failed to apply init.sql via socket, trying TCP..."
      mysql -h mariadb -u root -ppassword1234 < /etc/my.cnf.d/init.sql || {
        echo "Failed to apply init.sql even via TCP"
        exit 1
      }
    }
    echo "init.sql applied successfully"
  fi
else
  echo "Applying init.sql on fresh install..."
  mysql --socket=/run/mysqld/mysqld.sock -u root < /etc/my.cnf.d/init.sql || {
    echo "Failed to apply init.sql via socket"
    exit 1
  }
  echo "init.sql applied successfully"
fi

# Stop the temporary MariaDB instance
echo "Shutting down temporary MariaDB..."
mysqladmin -h mariadb -u root -ppassword1234 shutdown || {
  echo "Shutdown failed, forcing kill..."
  killall mysqld
  sleep 2
}

# Start MariaDB in the foreground
echo "Starting MariaDB in foreground..."
exec mysqld --user=root --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock --pid-file=/run/mysqld/mysqld.pid --console