#!/bin/bash
# Public MWMBashScript: Check out primary system aspects.
printf "\e[0;91m"
set -a
source ./my-system.env "$1" || { echo "FAILURE: Change directory to mediawiki-cli/" ; exit 1 ; }
set +a
printf "\e[0m"
if [ -n "$DEBUG" ] ; then echo "RUN LEX2110091037" ; fi

docker logs -f $MEDIAWIKI_CONTAINER_NAME