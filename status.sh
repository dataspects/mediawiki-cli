#!/bin/bash
# Public MWCLIBashScript: Check out primary system aspects.
printf "\e[0;91m"
set -a
source ./my-system.env "$1" || { echo "FAILURE: Change directory to mediawiki-cli/" ; exit 1 ; }
set +a
printf "\e[0m"
if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080552" ; fi


./view/view-mwm-config.sh
exit
./manage-system/show-composerLocalJSON.sh
./system-snapshots/view-restic-snapshots.sh
./manage-extensions/show-extension-catalogue.sh
# ./report-podman.sh