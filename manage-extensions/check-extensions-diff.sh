#!/bin/bash

source ./lib/utils.sh

printf "Comparing system_root/w/extensions/ <<<>>> existing_version/extensions/\n\n"
diff --brief \
 system_root/w/extensions/ \
 existing_version/extensions/ \
 | grep --color=auto Only

printf "\nComparing:\tsystem_root/w/composer.local.json/\t\tAGAINST\t\texisting_version/composer.local.json\n\n"
diff --side-by-side --suppress-common-lines \
    system_root/w/composer.local.json existing_version/composer.local.json