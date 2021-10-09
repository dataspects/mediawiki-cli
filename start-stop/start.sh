#!/bin/bash
# Public MWCLIBashScript: Start MWM System.
printf "\e[0;91m"
set -a
source ./my-system.env "$1" || { echo "FAILURE: Change directory to mediawiki-cli/" ; exit 1 ; }
set +a
printf "\e[0m"
if [ -n "$DEBUG" ] ; then echo "RUN LEX2110091035" ; fi

docker-compose \
    --file $DOCKER_COMPOSE_YML \
    up --detach

exit
source ../mediawiki-cli/config-db/lib.sh
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/lib/utils.sh
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/config-db/lib.sh
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/logging/lib.sh

sudo $CONTAINER_COMMAND pod start $POD_NAME
sudo $CONTAINER_COMMAND container start $POD_NAME-mediawiki
sleep 5
compileMWMLocalSettings
source $MEDIAWIKI_CLI_ON_HOSTING_SYSTEM/lib/waitForMariaDB.sh