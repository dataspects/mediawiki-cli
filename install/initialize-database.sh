#!/bin/bash
# Public MWMBashScript: Upgrade MWM System to new container image from https://hub.docker.com/r/dataspects/mediawiki/tags

# echo "Create database and user..."
mysql -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASSWORD \
  -e " CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;
        CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
        GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$MYSQL_USER'@'%';
        FLUSH PRIVILEGES;"

echo "Import database..."
  mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD \
  mediawiki < /var/www/html/w/db.sql