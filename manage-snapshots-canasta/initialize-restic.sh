#!/bin/bash

source $CANASTA_ROOT/.env
echo "INFO: Restic repo is $RESTIC_REPOSITORY"


sudo docker run \
    --rm -i --env-file $CANASTA_ROOT/.env \
    restic/restic \
    -r $RESTIC_REPOSITORY \
        init