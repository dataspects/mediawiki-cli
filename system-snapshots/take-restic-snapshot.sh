#!/bin/bash
# Public MWCLIBashScript: Take system snapshot.

source ./lib/runInContainerOnly.sh

TAG=$1

printf "Taking snapshot '$TAG'...\n"

######
# STEP 1: Dump content database
  mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
  $DATABASE_NAME > $CURRENT_RESOURCES_IN_CONTAINER/db.sql
printf "mysqldump mediawiki completed.\n"

######
# STEP 2: Copy folders and files
cp -r \
    $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/composer.local.json \
    $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/composer.local.lock \
    $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/extensions \
    $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/skins \
    $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/images \
    $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/vendor \
    $MWCLI_CONFIG_DB_IN_CONTAINER \
    $APACHE_CONF_IN_CONTAINER \
    $CURRENT_RESOURCES_IN_CONTAINER
  
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
    --repo $SYSTEM_SNAPSHOT_FOLDER_IN_CONTAINER \
    --password-file $RESTIC_PASSWORD_IN_CONTAINER \
    $TAGS \
      backup $CONTAINER_INTERNAL_PATH_TO_SNAPSHOT
printf "completed running restic backup.\n"