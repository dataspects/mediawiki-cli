#!/bin/bash
# Public MWCLIBashScript: Enable extensions selected from $CATALOGUE_URL.

if [ "`ls /home`" != "" ] ; then source ./lib/runInContainerOnly.sh ; fi

# FIXME: handle multiple system setups
source $MEDIAWIKI_CLI_IN_CONTAINER/lib/utils.sh
source $MEDIAWIKI_CLI_IN_CONTAINER/manage-extensions/utils.sh
source $MEDIAWIKI_CLI_IN_CONTAINER/lib/permissions.sh

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

$MEDIAWIKI_CLI_IN_CONTAINER/system-snapshots/take-restic-snapshot.sh BeforeEnabling-$EXTNAME

###
# Run installation aspects
if [ $cInstrFound ]
then
    # CreateCampEMWCon2021: run composer correctly
    echo "Running composer..."
    cd $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w && COMPOSER=composer.local.json COMPOSER_HOME=$SYSTEM_ROOT_FOLDER_IN_CONTAINER/w php composer.phar require $composer
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
        php $MEDIAWIKI_CLI_IN_CONTAINER/lib/addToMWCLISQLite.php "$EXTNAME" "$lsDirectives"
        if [[ $? == 0 ]]
        then
            echo "SUCCESS: $?"
        else
            echo "ERROR: $?"
        fi
    }
fi
###

php $MEDIAWIKI_CLI_IN_CONTAINER/lib/updatemwmLocalSettings.php
runMWUpdatePHP