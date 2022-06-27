#!/bin/bash

source $CANASTA_ROOT/.env

if [[ -z "$1" ]]; then
  echo 'You must provide a restic snapshot ID as $1!'
  exit
fi

SNAPSHOT_ID=$1

result=$(sudo docker exec -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
  $(basename $(tr [A-Z] [a-z] <<< "$CANASTA_ROOT"))_web_1 bash \
    -c 'mysql -h db -u root -p$MYSQL_PASSWORD -e "SHOW DATABASES LIKE \"my_wki\";"')

if [ -n "$result" ]; then
  printf "Database $result exists. Taking snapshot...\n"
  ./take-restic-snapshot.sh BeforeRestoring-$SNAPSHOT_ID
  printf "Snapshot taken...\n"
else
  printf "Initializing database...\n"
  sudo docker exec -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
      $(basename $(tr [A-Z] [a-z] <<< "$CANASTA_ROOT"))_web_1 bash \
        -c 'mysql -h db -u root -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $WG_DB_NAME"'
  printf "Initialized database...\n"

fi

currentsnapshotFolder="$CANASTA_ROOT/currentsnapshot"
if [ -d $currentsnapshotFolder ]; then
  printf "Emptying '$currentsnapshotFolder'...\n"
  sudo rm -r $currentsnapshotFolder/*
  printf "Emptied '$currentsnapshotFolder'...\n"
else
  mkdir $currentsnapshotFolder
fi

sudo docker run \
    --rm -i --env-file $CANASTA_ROOT/.env \
    -v $currentsnapshotFolder:/currentsnapshot \
    restic/restic \
    -r s3:$AWS_S3_API/$AWS_S3_BUCKET \
      restore $SNAPSHOT_ID \
        --target /currentsnapshot

# FIXME: are // a problem in paths?

printf "Copying files...\n"
sudo rm -rf $CANASTA_ROOT/config/*;
sudo cp -r --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/currentsnapshot/config/* $CANASTA_ROOT/config/; \
sudo rm -rf $CANASTA_ROOT/extensions/*;
sudo cp -r --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/currentsnapshot/extensions/* $CANASTA_ROOT/extensions/; \
sudo rm -rf $CANASTA_ROOT/images/*;
sudo cp -r --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/currentsnapshot/images/* $CANASTA_ROOT/images/; \
sudo rm -rf $CANASTA_ROOT/skins/*;
sudo cp -r --preserve=links,mode,ownership,timestamps $currentsnapshotFolder/currentsnapshot/skins/* $CANASTA_ROOT/skins/; \
printf "Copied files...\n"


printf "Restoring database...\n"
sudo docker exec -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
    $(basename $(tr [A-Z] [a-z] <<< "$CANASTA_ROOT"))_web_1 bash \
      -c 'mysql -h db -u root -p$MYSQL_PASSWORD $WG_DB_NAME < /mediawiki/config/db.sql'
printf "Restored database...\n"