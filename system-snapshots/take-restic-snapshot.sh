#!/bin/bash
# Public MWCLIBashScript: Take system snapshot.

source ./lib/runInContainerOnly.sh

CONTAINER_INTERNAL_PATH_TO_SNAPSHOT=/var/www/html/currentresources

TAG=$1

printf "Taking snapshot '$TAG'...\n"

######
# STEP 1: Dump content database
  mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
  $DATABASE_NAME > $CONTAINER_INTERNAL_PATH_TO_SNAPSHOT/db.sql
printf "mysqldump mediawiki completed.\n"

######
# STEP 2: Copy folders and files
cp -r \
    /var/www/html/w/composer.local.json \
    /var/www/html/w/composer.local.lock \
    /var/www/html/w/extensions \
    /var/www/html/w/skins \
    /var/www/html/w/images \
    /var/www/html/w/vendor \
    /var/www/html/mwcliconfigdb.sqlite \
    /etc/apache2/sites-available \
    $CONTAINER_INTERNAL_PATH_TO_SNAPSHOT
  
printf "copy folders and files completed.\n"

if [[ $TAG == "" ]]
then
    TAGS=""
else
    TAGS="--tag $TAG"
fi

######
# STEP 3: Run restic backup
restic \
    --repo $MEDIAWIKI_SNAPSHOT_FOLDER_IN_CONTAINER \
    --password-file $RESTIC_PASSWORD_IN_CONTAINER \
    $TAGS \
      backup $CONTAINER_INTERNAL_PATH_TO_SNAPSHOT
printf "completed running restic backup.\n"