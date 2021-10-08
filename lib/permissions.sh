#!/bin/bash

# CreateCampEMWCon2021: Check general permissions

if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080658" ; fi

setPermissionsOnSystemInstanceRoot () {

    dir=$MWCLI_SYSTEM_LOG_ON_HOSTING_SYSTEM
    if [ -d $dir ]
    then
        sudo chown -R $LOCALUSER:www-data $dir
        # FIXME: 777
        sudo chmod -R 777 $dir
    fi

    dir=$SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM/w
    if [ -d $dir ]
    then
        sudo chown -R $LOCALUSER:www-data $dir
        # FIXME: 777
        sudo chmod -R 777 $dir
    fi

    dir=$SYSTEM_SNAPSHOT_FOLDER_ON_HOSTING_SYSTEM
    if [ -d $dir ]
    then
        sudo chown -R $LOCALUSER:www-data $dir
        # FIXME: 777
        sudo chmod -R 777 $dir
    fi

    writeToSystemLog "Permissions set on host volumes"
}

export -f setPermissionsOnSystemInstanceRoot