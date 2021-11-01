#!/bin/bash

echo "Import /var/www/html/w/db.sql into $DATABASE_NAME..."
  mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD \
  $DATABASE_NAME < /var/www/html/w/db.sql