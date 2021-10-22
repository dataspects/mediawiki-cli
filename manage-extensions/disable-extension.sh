    #!/bin/bash
    # Public MWCLIBashScript: Disable extensions selected from $CATALOGUE_URL.

    source /var/www/manage/manage-extensions/utils.sh
    source /var/www/manage/lib/utils.sh
    source /var/www/manage/lib/permissions.sh

    # https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/
    # https://edoras.sdsu.edu/doc/sed-oneliners.html


    EXTNAME=$1

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

    /var/www/manage/manage-snapshots/take-restic-snapshot.sh BeforeDisabling-$EXTNAME

    ###
    # Check installation aspects
    if [ $cInstrFound ] && [ $rInstrFound ]
    then
        echo "Problem: Installation aspects for $EXTNAME contain both composer and repository specifications!"
        exit
    fi

    ###
    # Run installation aspects
    if [ $cInstrFound ]
    then
        echo "Running composer..."
        echo $(cat /var/www/html/w/composer.local.json | jq "del(.require.\"$composer\")") > /var/www/html/w/composer.local.json
        cd /var/www/html/w && COMPOSER=composer.json COMPOSER_HOME=/var/www/html/w php composer.phar update
        cd -
        echo "Ran composer"
    fi
    if [ $rInstrFound ]
    then
        echo "Running repository"
    fi
    if [ $lsInstrFound ]
    then
        echo "Running localsettings"
        echo `pwd`
        echo $localSettings | jq -r '.[]' | while read lsLine
        do
            php /var/www/manage/manage-config/removeFromMWMSQLite_by_name.php "$EXTNAME"
        done
    fi
    ###

    php /var/www/manage/manage-config/compileMWMLocalSettings.php
    runMWUpdatePHP