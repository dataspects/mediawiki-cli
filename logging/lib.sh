#!/bin/bash

if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080656" ; fi

# Public MWCLIBashFunction
initializeSystemLog () {
    FILE=$MWCLI_SYSTEM_LOG_ON_HOSTING_SYSTEM/system.log
    if [[ ! -f "$FILE" ]]
    then
        mkdir --parents $MWCLI_SYSTEM_LOG_ON_HOSTING_SYSTEM
        rm $FILE
        touch $FILE
    fi
}

export -f initializeSystemLog

# Public MWCLIBashFunction
writeToSystemLog () {
    # TODO: fix timestamp
    printf "$1\n"
    echo $(date "+%Y-%m-%d") $1>> $MWCLI_SYSTEM_LOG_ON_HOSTING_SYSTEM/system.log
}

export -f writeToSystemLog