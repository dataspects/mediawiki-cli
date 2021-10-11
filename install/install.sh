#!/bin/bash
if [[ -z "$1" ]]; then
  echo 'Provide path to .env file as $1!'
  exit
fi

###############################################################################
printf "\e[0;91m"
set -a
source $1 || { echo "FAILURE: Change directory to mediawiki-cli/" ; exit 1 ; }
set +a
printf "\e[0m"
###############################################################################

if [ -n "$DEBUG" ] ; then echo "RUN LEX2110111218" ; fi

###############################################################################
envsubst < templates/docker-compose.tpl > ../docker-compose-dataspects-mediawiki.yml
docker-compose --file ../docker-compose-dataspects-mediawiki.yml up -d
###############################################################################

./run-shared-sh-command.sh waitForMariaDB.sh

###############################################################################
./run-shared-sh-command.sh initialize-database.sh
./run-shared-sh-command.sh maintenance-update.php.sh
###############################################################################