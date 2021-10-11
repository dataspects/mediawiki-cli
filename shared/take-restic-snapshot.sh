#!/bin/bash
# Public MWCLIBashScript: Take system snapshot.

if [[ -z "$1" ]]; then
  echo 'You must provide a restic backup tag as $1!'
  exit
fi

TAG=$1
printf "Taking snapshot '$TAG'...\n"

######
# STEP 1: Dump content database
  mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD \
  $DATABASE_NAME > /var/www/currentresources/db.sql
printf "mysqldump mediawiki completed.\n"

######
# STEP 2: Copy folders and files
cp -r \
    /var/www/html/w/extensions \
    /var/www/html/w/skins \
    /var/www/html/w/images \
    /var/www/html/w/vendor \
    /var/www/html/mwmconfigdb.sqlite \
    /var/www/currentresources

# /var/www/html/w/composer.local.json \
# /var/www/html/w/composer.local.lock \

printf "copy folders and files completed.\n"

######
# STEP 3: Run restic backup
restic \
    --repo /var/www/snapshots \
    --password-file /var/www/restic_password \
    --tag $TAG \
      backup /var/www/currentresources
printf "completed running restic backup.\n"