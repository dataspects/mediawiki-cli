#!/bin/bash
# Public MWCLIBashScript: Restore system snapshot.

source $CANASTA_ROOT/.env
echo "INFO: Restic repo is $RESTIC_REPOSITORY"


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
    --rm -i --env-file $CANASTA_ROOT/.env \
    restic/restic \
    -r $RESTIC_REPOSITORY \
      diff $SNAPSHOT_ID0 $SNAPSHOT_ID1