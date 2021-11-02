#!/bin/bash
# Public MWCLIBashScript: Check out primary system aspects.
clear
printf "\n\033[0;32m\e[1m/var/www/config/mwmconfigdb.sqlite\033[0m"
printf "\n==================================\n"
php /var/www/manage/manage-config/view-mwm-config.php

printf "\n\033[0;32m\e[1m/var/www/config/mwmLocalSettings.php\033[0m"
printf "\n==================================\n"
cat /var/www/config/mwmLocalSettings.php

printf "\n\033[0;32m\e[1m/var/www/config/mmwmLocalSettings_manual.php\033[0m"
printf "\n==================================\n"
cat /var/www/config/mwmLocalSettings_manual.php

./manage-extensions/show-composerLocalJSON.sh
./manage-snapshots/view-restic-snapshots.sh
./manage-extensions/show-extension-catalogue.sh