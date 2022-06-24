#!/bin/bash

if [[ -z "$1" ]]; then
  echo 'You must provide a restic snapshot tag as $1!'
  exit
fi

TAG=$1
printf "Taking snapshot '$TAG'...\n"
currentsnapshotFolder="currentsnapshot"
if [ -d $currentsnapshotFolder ]; then
  printf "Emptying '$currentsnapshotFolder'...\n"
  rm -r $currentsnapshotFolder/*
  printf "Emptied '$currentsnapshotFolder'...\n"
else
  mkdir $currentsnapshotFolder
fi

######
# STEP 1: Dump content database
  mysqldump -h db -u root -p$MYSQL_PASSWORD \
  my_wiki > $currentsnapshotFolder/db.sql
printf "mysqldump mediawiki completed.\n"

######
# STEP 2: Copy folders and files
cp --preserve=links,mode,ownership,timestamps -r \
    /home/lex/Canasta-DockerCompose/config \
    /home/lex/Canasta-DockerCompose/extensions \
    /home/lex/Canasta-DockerCompose/images \
    /home/lex/Canasta-DockerCompose/skins \
    $currentsnapshotFolder

printf "copy folders and files completed.\n"

######
# STEP 3: Run restic backup
sudo docker run \
    --rm -i --env-file .env \
    restic/restic \
    -r s3:$AWS_S3_API/$AWS_S3_BUCKET --tag $TAG \
  backup $currentsnapshotFolder
printf "completed running restic backup.\n"
