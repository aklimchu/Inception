FROM alpine:3.20.2

RUN apk update && apk upgrade && apk add mariadb mariadb-client

COPY conf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/init.sql /etc/my.cnf.d/init.sql
COPY tools/mariadb_script.sh .

# Ensure required directories exist and set ownership (should it be root instead?)
RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R root:root /run/mysqld /var/lib/mysql && \
    chmod +x mariadb_script.sh

# Initialize the database
#RUN mysql_install_db --user=root --datadir=/var/lib/mysql

EXPOSE 3306

# Set up MariaDB to start with the container
CMD ["sh", "/mariadb_script.sh"]