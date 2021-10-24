#!/bin/bash
# Public MWCLIBashScript: Show extensions featured in $CATALOGUE_URL.

source /var/www/manage/lib/utils.sh
source /var/www/manage/manage-extensions/utils.sh

getExtensionJSON
printf "\n\033[0;32m\e[1mMWStake Certified Extensions Catalog\033[0m"
printf "\n====================================\n"
printf "$CATALOGUE_URL\n\n"
printf "\n<EXTENSION_NAME>\n----------------\n"
echo $catalogueJSON | jq '.[]' | jq -r '.name'
printf "\n====================================\n\n"
printf "To enable <EXTENSION_NAME> run  : ./manage-extensions/enable-extension.sh <EXTENSION_NAME>\n"
printf "To disable <EXTENSION_NAME> run : ./manage-extensions/disable-extension.sh <EXTENSION_NAME>\n"
printf "\n"