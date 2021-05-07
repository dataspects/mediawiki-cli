#!/bin/bash

# Public MWCLIBashFunction
initializeSystemLog () {
    FILE=./logs/system.log
    if [[ ! -f "$FILE" ]]
    then
        mkdir --parents logs
        rm $FILE
        touch $FILE
    fi
}

# Public MWCLIBashFunction
writeToSystemLog () {
    # TODO: fix timestamp
    printf "$1\n"
    echo $(date "+%Y-%m-%d") $1>> ./logs/system.log
}