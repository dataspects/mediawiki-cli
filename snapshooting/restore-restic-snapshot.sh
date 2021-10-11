#!/bin/bash
# Public MWCLIBashScript: Restore system snapshot.

if [ "`ls /home`" != "" ] ; then source ./lib/runInContainerOnly.sh ; fi

SNAPSHOT_ID=$1

# If it is "latest", then we're coming from an upgrade, which already had a snapshot
# right before running

if [[ $SNAPSHOT_ID != "latest" ]]
then
    ./system-snapshots/take-restic-snapshot.sh BeforeRestoring-$SNAPSHOT_ID
fi


restic \
    --repo $SYSTEM_SNAPSHOT_FOLDER_IN_CONTAINER \
    --password-file $RESTIC_PASSWORD_IN_CONTAINER \
        restore $SNAPSHOT_ID \
            --target $CURRENT_RESOURCES_IN_CONTAINER

cp $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/composer.local.json $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/composer.local.json; \
cp $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/composer.local.lock $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/composer.local.lock; \
cp $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/mwmconfigdb.sqlite /var/www/html/mwmconfigdb.sqlite; \
rm -rf $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/extensions/*;
cp -r --preserve=links $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/extensions/* $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/extensions/; \
rm -rf $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/skins/*;
cp -r --preserve=links $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/skins/* $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/skins/; \
rm -rf $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/images/*;
cp -r --preserve=links $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/images/* $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/images/; \
rm -rf $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/vendor/*;
cp -r --preserve=links $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/vendor/* $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/vendor/; \
rm -rf /etc/apache2/sites-available/*;
cp -r --preserve=links $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/sites-available/* /etc/apache2/sites-available/;

mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD \
    $DATABASE_NAME < $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/db.sql

php $MEDIAWIKI_CLI_IN_CONTAINER/lib/updatemwmLocalSettings.php
cd $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w && COMPOSER_HOME=$SYSTEM_ROOT_FOLDER_IN_CONTAINER/w php composer.phar update
cd -