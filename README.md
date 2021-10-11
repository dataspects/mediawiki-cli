# mediawiki-cli

mediawiki-cli$

./start-stop/stop.sh \
&& docker volume prune \
&& ./start-stop/start.sh \
&& ./run-shared-sh-command.sh waitForMariaDB.sh \
&& ./run-shared-sh-command.sh initialize-database.sh \
&& ./run-shared-sh-command.sh maintenance-update.php.sh \
&& ./run-shared-sh-command.sh initialize-mwcliconfigdb.sh \
&& ./run-shared-php-command.sh 'addToMWMSQLite.php "maintenance" "\$wgReadOnly = 'ReadOnly';"' \
&& ./run-shared-php-command.sh compileMWMLocalSettings.php \
&& ./run-shared-php-command.sh view-mwm-config.php
* ./run-shared-php-command.sh 'removeFromMWMSQLite.php "one"'

## Development

    ~/mediawiki-cli$ docker-compose \
        --file ../docker-compose-dataspects-mediawiki.yml down \
        && docker volume prune \
        && ./install/install.sh ./my-system.env