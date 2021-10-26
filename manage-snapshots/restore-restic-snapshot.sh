#!/bin/bash
# Public MWCLIBashScript: Restore system snapshot.

if [[ -z "$1" ]]; then
  echo 'You must provide a restic snapshot ID as $1!'
  exit
fi

SNAPSHOT_ID=$1

# If it is "latest", then we're coming from an upgrade, which already had a snapshot
# right before running
if [[ $SNAPSHOT_ID != "latest" ]]
then
    ./manage-snapshots/take-restic-snapshot.sh BeforeRestoring-$SNAPSHOT_ID
fi

currentsnapshotFolder="/var/www/currentsnapshot"
if [ -d $currentsnapshotFolder ]; then
  printf "Emptying '$currentsnapshotFolder'...\n"
  rm -r $currentsnapshotFolder/*
  printf "Emptied '$currentsnapshotFolder'...\n"
else
  mkdir $currentsnapshotFolder
fi

restic -r s3:$AWS_S3_API/$AWS_S3_BUCKET \
    restore $SNAPSHOT_ID \
        --target $currentsnapshotFolder

# FIXME: are // a problem in paths?

printf "Copying files...\n"
cp --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/composer.local.json /var/www/html/w/composer.local.json; \
cp --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/composer.local.lock /var/www/html/w/composer.local.lock; \
cp --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/mwmconfigdb.sqlite /var/www/config/mwmconfigdb.sqlite; \
cp --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/mwmLocalSettings.php /var/www/config/mwmLocalSettings.php; \
cp --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/mwmLocalSettings_manual.php /var/www/config/mwmLocalSettings_manual.php; \
rm -rf /var/www/html/w/extensions/*;
cp -r --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/extensions/* /var/www/html/w/extensions/; \
rm -rf /var/www/html/w/skins/*;
cp -r --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/skins/* /var/www/html/w/skins/; \
rm -rf /var/www/html/w/images/*;
cp -r --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/images/* /var/www/html/w/images/; \
rm -rf /var/www/html/w/vendor/*;
cp -r --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/vendor/* /var/www/html/w/vendor/; \
printf "Copied files...\n"

# FIXME: necessary?
printf "Chowning files...\n"
chown -R www-data:root /var/www/html/w
printf "Chowned files...\n"

printf "Restoring database...\n"
mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD \
    $DATABASE_NAME < $currentsnapshotFolder/$currentsnapshotFolder/db.sql
printf "Restored database...\n"

php /var/www/manage/manage-config/compileMWMLocalSettings.php
cd /var/www/html/w && COMPOSER=composer.json COMPOSER_HOME=/var/www/html/w php composer.phar update
cd -