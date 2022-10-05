#!/bin/bash

source $CANASTA_ROOT/.env
echo "INFO: Restic repo is $RESTIC_REPOSITORY"


if [[ -z "$1" ]]; then
  echo 'You must provide a restic snapshot ID as $1!'
  exit
fi

SNAPSHOT_ID=$1

sudo docker run \
    --rm -i --env-file $CANASTA_ROOT/.env \
    restic/restic \
    -r $RESTIC_REPOSITORY \
      forget $SNAPSHOT_ID