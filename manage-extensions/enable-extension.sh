#!/bin/bash
# Public MWCLIBashScript: Enable extensions selected from $CATALOGUE_URL.

# FIXME: handle multiple system setups

# https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/
# https://edoras.sdsu.edu/doc/sed-oneliners.html

source /var/www/manage/lib/utils.sh

if [[ -z "$1" ]]; then
  echo 'You must provide an extension name as $1!'
  exit
fi

EXTENSION_NAME=$1

/var/www/manage/manage-snapshots/take-restic-snapshot.sh BeforeEnabling-$EXTENSION_NAME

php /var/www/manage/manage-extensions/enable-extension.php $EXTENSION_NAME

runMWUpdatePHP