#!/bin/bash

source $CANASTA_ROOT/.env

if [[ -z "$1" ]]; then
  echo 'You must provide a restic snapshot ID as $1!'
  exit
fi

SNAPSHOT_ID=$1

sudo docker run \
    --rm -i --env-file $CANASTA_ROOT/.env \
    restic/restic \
    -r s3:$AWS_S3_API/$AWS_S3_BUCKET \
      ls $SNAPSHOT_ID