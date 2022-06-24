#!/bin/bash

source $CANASTA_ROOT/.env

if [[ -z "$1" ]]; then
  echo 'You must provide a restic snapshot ID as $1!'
  exit
fi

SNAPSHOT_ID=$1

# If it is "latest", then we're coming from an upgrade, which already had a snapshot
# right before running
if [[ $SNAPSHOT_ID != "latest" ]]
then
    ./take-restic-snapshot.sh BeforeRestoring-$SNAPSHOT_ID
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
    canasta-dockercompose_web_1 bash \
      -c 'mysql -h db -u root -p$MYSQL_PASSWORD my_wiki < /mediawiki/config/db.sql'
printf "Restored database...\n"