#!/bin/bash
# Public MWCLIBashScript: Upgrade MWCLI System to new container image from https://hub.docker.com/r/dataspects/mediawiki/tags

source ./lib/utils.sh
source ./lib/permissions.sh
source ./my-system.env

echo -n "Enter MEDIAWIKI_IMAGE, e.g. 'docker.io/dataspects/mediawiki:1.35.1-2104141705': "
read MEDIAWIKI_IMAGE

./system-snapshots/take-restic-snapshot.sh BeforeUpgrade

./manage-system/stop.sh
$CONTAINER_COMMAND pod rm mwcli-deployment-pod-0

envsubst < mediawiki-manager.tpl > mediawiki-manager.yml
$CONTAINER_COMMAND play kube mediawiki-manager.yml

./system-snapshots/restore-restic-snapshot.sh latest

source ./lib/waitForMariaDB.sh

source ./my-system.env
$CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "cd /var/www/html/w && COMPOSER_HOME=/var/www/html/w php composer.phar update"

runMWUpdatePHP