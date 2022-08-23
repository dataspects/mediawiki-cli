#!/bin/bash

source $CANASTA_ROOT/.env

cd $CANASTA_ROOT
sudo docker-compose down
sudo docker-compose up -d
cd -