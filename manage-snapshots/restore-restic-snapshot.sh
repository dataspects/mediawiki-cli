#!/bin/bash
# Public MWCLIBashScript: Restore system snapshot.

SNAPSHOT_ID=$1

# If it is "latest", then we're coming from an upgrade, which already had a snapshot
# right before running
# if [[ $SNAPSHOT_ID != "latest" ]]
# then
#     ./system-snapshots/take-restic-snapshot.sh BeforeRestoring-$SNAPSHOT_ID
# fi

rm -r /var/www/restoresnapshot
mkdir /var/www/restoresnapshot

restic -r s3:$AWS_S3_API/$AWS_S3_BUCKET \
    restore $SNAPSHOT_ID \
        --target /var/www/restoresnapshot

# cp $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/composer.local.json /var/www/html/w/composer.local.json; \
# cp $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/composer.local.lock /var/www/html/w/composer.local.lock; \
# cp $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/mwmconfigdb.sqlite /var/www/config/mwmconfigdb.sqlite; \
# rm -rf /var/www/html/w/extensions/*;
# cp -r --preserve=links $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/extensions/* /var/www/html/w/extensions/; \
# rm -rf /var/www/html/w/skins/*;
# cp -r --preserve=links $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/skins/* /var/www/html/w/skins/; \
# rm -rf /var/www/html/w/images/*;
# cp -r --preserve=links $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/images/* /var/www/html/w/images/; \
# rm -rf /var/www/html/w/vendor/*;
# cp -r --preserve=links $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/vendor/* /var/www/html/w/vendor/; \
# rm -rf /etc/apache2/sites-available/*;
# cp -r --preserve=links $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/sites-available/* /etc/apache2/sites-available/;

# mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD \
#     $DATABASE_NAME < $CURRENT_RESOURCES_IN_CONTAINER/var/www/html/currentresources/db.sql

# php /var/www/manage/mediawiki-cli/manage-config/updatemwmLocalSettings.php
# cd /var/www/html/w && COMPOSER_HOME=/var/www/html/w php composer.phar update
# cd -