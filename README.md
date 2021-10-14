# mediawiki-cli for dataspects Snoopy

mediawiki-cli$

./start-stop/stop.sh \
&& docker volume prune \
&& ./start-stop/start.sh \
&& ./run-shared-sh-command.sh waitForMariaDB.sh \
&& ./run-shared-sh-command.sh initialize-database.sh \
&& ./run-shared-sh-command.sh maintenance-update.php.sh \
&& ./run-shared-sh-command.sh initialize-mwcliconfigdb.sh \
&& ./run-shared-php-command.sh 'addToMWMSQLite.php "maintenance" "\$wgServer = 'ReadOnly';"' \
&& ./run-shared-php-command.sh compileMWMLocalSettings.php \
&& ./run-shared-php-command.sh view-mwm-config.php
* ./run-shared-php-command.sh 'removeFromMWMSQLite.php "one"'

# Install

1. Edit `~/mediawiki-cli$ ./my-system.env`
2. Run `~/mediawiki-cli$ ./install/install.sh`

## Snoopy

### ubuntu@snoopy:~$
    
    docker exec -it <WIKI_CONTAINER> /bin/bash

### root@35adcced231c:/var/www/html#

    cd /var/www/manage/mediawiki-cli/

    ./manage-extensions/show-extension-catalogue.sh
    