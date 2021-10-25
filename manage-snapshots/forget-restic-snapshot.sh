#!/bin/bash
# Public MWCLIBashScript: Restore system snapshot.

if [[ -z "$1" ]]; then
  echo 'You must provide a restic snapshot ID as $1!'
  exit
fi

SNAPSHOT_ID=$1

restic -r s3:$AWS_S3_API/$AWS_S3_BUCKET \
    forget $SNAPSHOT_ID