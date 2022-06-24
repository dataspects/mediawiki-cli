#!/bin/bash

source $CANASTA_ROOT/.env

sudo docker run \
    --rm -i --env-file $CANASTA_ROOT/.env \
    restic/restic \
    -r s3:$AWS_S3_API/$AWS_S3_BUCKET \
        snapshots