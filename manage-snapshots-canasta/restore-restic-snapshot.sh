#!/bin/bash

source /home/lex/Canasta-DockerCompose/.env

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

currentsnapshotFolder="/home/lex/Canasta-DockerCompose/currentsnapshot"
if [ -d $currentsnapshotFolder ]; then
  printf "Emptying '$currentsnapshotFolder'...\n"
  sudo rm -r $currentsnapshotFolder/*
  printf "Emptied '$currentsnapshotFolder'...\n"
else
  mkdir $currentsnapshotFolder
fi

sudo docker run \
    --rm -i --env-file /home/lex/Canasta-DockerCompose/.env \
    -v $currentsnapshotFolder:/currentsnapshot \
    restic/restic \
    -r s3:$AWS_S3_API/$AWS_S3_BUCKET \
      restore $SNAPSHOT_ID \
        --target /currentsnapshot

# FIXME: are // a problem in paths?

printf "Copying files...\n"
cp --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/config /home/lex/Canasta-DockerCompose/config; \
cp --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/extensions /home/lex/Canasta-DockerCompose/extensions; \
cp --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/images /home/lex/Canasta-DockerCompose/images; \
cp --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/$currentsnapshotFolder/skins /home/lex/Canasta-DockerCompose/skins; \
printf "Copied files...\n"

# FIXME: necessary?
printf "Chowning files...\n"
chown -R www-data:root /var/www/html/w
printf "Chowned files...\n"

printf "Restoring database...\n"
sudo docker exec -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    canasta-dockercompose_web_1 bash \
      -c 'mysql -h db -u root -p$MYSQL_PASSWORD $DATABASE_NAME < /mediawiki/config/db.sql'
printf "Restored database...\n"