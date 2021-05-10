#!/bin/bash
# Public MWCLIBashScript: Enable extensions selected from $CATALOGUE_URL.

source ./lib/runInContainerOnly.sh

# FIXME: handle multiple system setups
source ./lib/utils.sh
source ./manage-extensions/utils.sh
source ./lib/permissions.sh

# https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/
# https://edoras.sdsu.edu/doc/sed-oneliners.html

EXTNAME=$1

declare lsDirectives

###
# Collect installation aspects
getExtensionData $EXTNAME
installationAspects=`getExtensionDataByKey "installation-aspects" "$extensionData"`
composer=`getExtensionDataByKey "composer" "$installationAspects"`
repository=`getExtensionDataByKey "repository" "$installationAspects"`
localSettings=`getExtensionDataByKey "localsettings" "$installationAspects"`
if [ "$composer" != "null" ]; then cInstrFound=true; fi
if [ "$repository" != "null" ]; then rInstrFound=true; fi
if [ "$localSettings" != "null" ]; then lsInstrFound=true; fi
###

###
# Check installation aspects
if [ $cInstrFound ] && [ $rInstrFound ]
then
    echo "Problem: Installation aspects for $EXTNAME contain both composer and repository specifications!"
    exit
fi
###

./system-snapshots/take-restic-snapshot.sh BeforeEnabling-$EXTNAME

###
# Run installation aspects
if [ $cInstrFound ]
then
    # CreateCampEMWCon2021: run composer correctly
    echo "Running composer..."
    cd /var/www/html/w && COMPOSER=composer.local.json COMPOSER_HOME=/var/www/html/w php composer.phar require $composer
    cd -
    echo "Ran composer"
fi
# Note: BACKUP composer lock file, restore, and run composer update, which will look at lock file
if [ $rInstrFound ]
then
    echo "Running repository"
    git clone $repository w/extensions/$EXTNAME
fi
if [ $lsInstrFound ]
then
    echo "Running localsettings"
    lsDirectives=""
    echo $localSettings | jq -r '.[]' | { 
        while read lsLine
        do
            lsDirectives="$lsDirectives $lsLine"
        done
        php ./lib/addToMWCLISQLite.php "$EXTNAME" "$lsDirectives"
        if [[ $? == 0 ]]
        then
            echo "SUCCESS: $?"
        else
            echo "ERROR: $?"
        fi
    }
fi
###

php ./lib/updatemwmLocalSettings.php
runMWUpdatePHP