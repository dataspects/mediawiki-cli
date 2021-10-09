#!/bin/bash
# Public MWMBashScript: Restart MWM System.
printf "\e[0;91m"
set -a
source ./my-system.env "$1" || { echo "FAILURE: Change directory to mediawiki-cli/" ; exit 1 ; }
set +a
printf "\e[0m"
if [ -n "$DEBUG" ] ; then echo "RUN LEX2110091035" ; fi

docker-compose \
    --file $DOCKER_COMPOSE_YML \
    down
docker-compose \
    --file $DOCKER_COMPOSE_YML \
    up --detach