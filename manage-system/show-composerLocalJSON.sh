#!/bin/bash
# Public MWCLIBashScript: Check the current contents of $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w/composer.local.json.
source ./my-system.env
if $DEBUG ; then echo "RUN LEX2110080607" ; fi


printf "\n\033[0;32m\e[1mcomposer.local.json\033[0m"
printf "\n====================================\n"
jq . $SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w/composer.local.json
printf "\n"