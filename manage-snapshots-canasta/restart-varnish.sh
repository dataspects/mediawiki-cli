#!/bin/bash

source $CANASTA_ROOT/.env

cd $CANASTA_ROOT
sudo docker-compose restart varnish
cd -