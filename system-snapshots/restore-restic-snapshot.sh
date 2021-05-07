#!/bin/bash
# Public MWCLIBashScript: Restore system snapshot.

source ./lib/runInContainerOnly.sh

SNAPSHOT_ID=$1

# If it is "latest", then we're coming from an upgrade, which already had a snapshot
# right before running

if [[ $SNAPSHOT_ID != "latest" ]]
then
    ./system-snapshots/take-restic-snapshot.sh BeforeRestoring-$SNAPSHOT_ID
fi


restic \
    --repo $MEDIAWIKI_SNAPSHOT_FOLDER_IN_CONTAINER \
    --password-file $RESTIC_PASSWORD_IN_CONTAINER \
        restore $SNAPSHOT_ID \
            --target ./currentresources

cp ./currentresources/var/www/html/currentresources/composer.local.json /var/www/html/w/composer.local.json; \
cp ./currentresources/var/www/html/currentresources/composer.local.lock /var/www/html/w/composer.local.lock; \
cp ./currentresources/var/www/html/currentresources/mwcliconfigdb.sqlite /var/www/html/mwcliconfigdb.sqlite; \
rm -rf /var/www/html/w/extensions/*;
cp -r --preserve=links ./currentresources/var/www/html/currentresources/extensions/* /var/www/html/w/extensions/; \
rm -rf /var/www/html/w/skins/*;
cp -r --preserve=links ./currentresources/var/www/html/currentresources/skins/* /var/www/html/w/skins/; \
rm -rf /var/www/html/w/images/*;
cp -r --preserve=links ./currentresources/var/www/html/currentresources/images/* /var/www/html/w/images/; \
rm -rf /var/www/html/w/vendor/*;
cp -r --preserve=links ./currentresources/var/www/html/currentresources/vendor/* /var/www/html/w/vendor/; \
rm -rf /etc/apache2/sites-available/*;
cp -r --preserve=links ./currentresources/var/www/html/currentresources/sites-available/* /etc/apache2/sites-available/;

mysql -h $MYSQL_HOST -u $MYSQL_USER -p$WG_DB_PASSWORD \
    $DATABASE_NAME < ./currentresources/var/www/html/currentresources/db.sql

php ./lib/updateMWCLILocalSettings.php
cd /var/www/html/w && COMPOSER_HOME=/var/www/html/w php composer.phar update
cd -