FROM alpine:3.20.2

RUN apk update && apk upgrade && apk add mariadb mariadb-client

COPY conf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/init.sql /etc/my.cnf.d/init.sql
# do we ever run init.sql?

# Ensure required directories exist and set ownership
RUN mkdir -p /run/mysqld /var/lib/mysql && \
	chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Initialize the database
#RUN mysql_install_db --user=root --datadir=/var/lib/mysql

# Set up MariaDB to start with the container
CMD ["mysqld"]