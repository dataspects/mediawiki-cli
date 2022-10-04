#!/bin/bash

source $CANASTA_ROOT/.env
source destination.sh

if [[ -z "$1" ]]; then
  echo 'You must provide a restic snapshot tag as $1!'
  exit
fi

TAG=$1
printf "Taking snapshot '$TAG'...\n"
currentsnapshotFolder="$CANASTA_ROOT/currentsnapshot"
if [ -d $currentsnapshotFolder ]; then
  printf "Emptying '$currentsnapshotFolder'...\n"
  sudo rm -r $currentsnapshotFolder/*
  printf "Emptied '$currentsnapshotFolder'...\n"
else
  mkdir $currentsnapshotFolder
fi

######
# STEP 1: Dump content database
  sudo docker exec -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    $(basename $(tr [A-Z] [a-z] <<< "$CANASTA_ROOT"))_web_1 bash \
      -c 'mysqldump -h db -u root -p$MYSQL_PASSWORD --databases $WG_DB_NAME > /mediawiki/config/db.sql'
printf "mysqldump mediawiki completed.\n"

######
# STEP 2: Copy folders and files
cp --preserve=links,mode,ownership,timestamps -r \
    $CANASTA_ROOT/config \
    $CANASTA_ROOT/extensions \
    $CANASTA_ROOT/images \
    $CANASTA_ROOT/skins \
    $currentsnapshotFolder

printf "copy folders and files completed.\n"

######
# STEP 3: Run restic backup
sudo docker run \
    --rm -i --env-file $CANASTA_ROOT/.env \
    -v $currentsnapshotFolder:/currentsnapshot \
    restic/restic \
    -r $DESTINATION --tag ${TAG}__on__$(hostname) \
      backup /currentsnapshot
printf "completed running restic backup.\n"
