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
# DOCKER COMPOSE
#envsubst < templates/docker-compose.tpl > ../docker-compose-dataspects-mediawiki.yml
#docker-compose --file ../docker-compose-dataspects-mediawiki.yml up -d
###############################################################################

###############################################################################
# DATABASE + initialize
./run-shared-sh-command.sh waitForMariaDB.sh
./run-shared-sh-command.sh initialize-database.sh
./run-shared-sh-command.sh maintenance-update.php.sh
###############################################################################

###############################################################################
# LOCAL CONFIG
./run-shared-sh-command.sh initialize-mwcliconfigdb.sh
./run-shared-php-command.sh 'addToMWMSQLite.php "maintenance" "\$wgReadOnly = \"ReadOnly\";"'
./run-shared-php-command.sh view-mwm-config.php
./run-shared-php-command.sh compileMWMLocalSettings.php
###############################################################################

###############################################################################
# SNAPSHOOTING
./run-shared-sh-command.sh initialize-restic.sh
./run-shared-sh-command.sh 'take-restic-snapshot.sh initial-snapshot'
./run-shared-sh-command.sh view-restic-snapshots.sh
###############################################################################
