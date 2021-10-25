#!/bin/bash
# Public MWCLIBashScript: Take system snapshot.

if [[ -z "$1" ]]; then
  echo 'You must provide a restic snapshot tag as $1!'
  exit
fi

TAG=$1
printf "Taking snapshot '$TAG'...\n"
currentsnapshotFolder="/var/www/currentsnapshot"
if [ -d $currentsnapshotFolder ]; then
  printf "Emptying '$currentsnapshotFolder'...\n"
  rm -r $currentsnapshotFolder/*
  printf "Emptied '$currentsnapshotFolder'...\n"
else
  mkdir $currentsnapshotFolder
fi

######
# STEP 1: Dump content database
  mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD \
  $DATABASE_NAME > $currentsnapshotFolder/db.sql
printf "mysqldump mediawiki completed.\n"

######
# STEP 2: Copy folders and files
cp --preserve=links,mode,ownership,timestamps -r \
    /var/www/html/w/composer.local.json \
    /var/www/html/w/composer.local.lock \
    /var/www/html/w/extensions \
    /var/www/html/w/skins \
    /var/www/html/w/images \
    /var/www/html/w/vendor \
    /var/www/config/mwmconfigdb.sqlite \
    /var/www/config/mwmLocalSettings.php \
    $currentsnapshotFolder

printf "copy folders and files completed.\n"

######
# STEP 3: Run restic backup
restic -r s3:$AWS_S3_API/$AWS_S3_BUCKET --tag $TAG \
  backup $currentsnapshotFolder
printf "completed running restic backup.\n"

# FIXME: How to handle:
# Fatal: unable to open config file: Stat: Get http://192.168.1.36:9000/snoopy-mediawiki0/?location=: dial tcp 192.168.1.36:9000: i/o timeout
# Is there a repository at the following location?
# s3:http://192.168.1.36:9000/snoopy-mediawiki0
