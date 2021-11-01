#!/bin/bash
# Public MWMBashScript: Upgrade MWM System to new container image from https://hub.docker.com/r/dataspects/mediawiki/tags

echo "Import database..."
  mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD \
  $DATABASE_NAME < /var/www/html/w/db.sql