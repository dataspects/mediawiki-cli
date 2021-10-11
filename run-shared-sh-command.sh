#!/bin/bash
printf "\e[0;91m"
set -a
source ./my-system.env "$1"
source ./lib/utils.sh "$1"
set +a \
|| { echo "FAILURE: Change directory to mediawiki-cli/" ; exit 1 ; }
printf "\e[0m"
if [ -n "$DEBUG" ] ; then echo "RUN LEX2110091420" ; fi

docker exec --env-file ./my-system.env $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "../shared/$1"