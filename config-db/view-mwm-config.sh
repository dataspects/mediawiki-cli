#!/bin/bash
# Public MWCLIBashScript: Check which PHP directives are currently added to LocalSettings.php.
source ./my-system.env
if $DEBUG ; then echo "RUN LEX2110080553" ; fi

printf "\n\033[0;32m\e[1mMWCLI Config\033[0m"
printf "\n============\n"
source ./lib/runInContainerOnly.sh

php ./config-db/view-mwm-config.php
printf "\n====================\n\n"