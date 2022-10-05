#!/bin/bash

source $CANASTA_ROOT/.env
echo "INFO: Restic repo is $RESTIC_REPOSITORY"

cd $CANASTA_ROOT
sudo docker-compose restart varnish
cd -