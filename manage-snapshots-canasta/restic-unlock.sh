#!/bin/bash

source $CANASTA_ROOT/.env
source destination.sh

sudo docker run \
    --rm -i --env-file $CANASTA_ROOT/.env \
    restic/restic \
    -r $DESTINATION \
        unlock