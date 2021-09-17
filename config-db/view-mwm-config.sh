#!/bin/bash
# Public MWCLIBashScript: Check which PHP directives are currently added to LocalSettings.php.
source ./lib/runInContainerOnly.sh

printf "\n\033[0;32m\e[1mMWCLI Config\033[0m"
printf "\n====================\n"
php ./config-db/view-mwm-config.php
printf "\n====================\n\n"