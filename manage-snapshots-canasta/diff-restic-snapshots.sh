#!/bin/bash
# Public MWCLIBashScript: Restore system snapshot.

if [[ -z "$1" ]]; then
  echo 'You must provide a restic snapshot ID as $1!'
  exit
fi

if [[ -z "$2" ]]; then
  echo 'You must provide a restic snapshot ID as $2!'
  exit
fi

SNAPSHOT_ID0=$1
SNAPSHOT_ID1=$2

sudo docker run \
    --rm -i --env-file .env \
    restic/restic \
    -r s3:$AWS_S3_API/$AWS_S3_BUCKET \
      diff $SNAPSHOT_ID0 $SNAPSHOT_ID1