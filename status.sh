#!/bin/bash
# Public MWCLIBashScript: Check out primary system aspects.
printf "\n\033[0;32m\e[1mConfig database entries (SQLite)\033[0m"
printf "\n==================================\n"
php ./manage-config/view-mwm-config.php

printf "\n\033[0;32m\e[1mmwmLocalSettings_manual.php\033[0m"
printf "\n==================================\n"
cat /var/www/config/mwmLocalSettings_manual.php

./manage-extensions/show-composerLocalJSON.sh
./manage-snapshots/view-restic-snapshots.sh
./manage-extensions/show-extension-catalogue.sh