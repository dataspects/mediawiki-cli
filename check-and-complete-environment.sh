#!/bin/bash
if [ -n "$DEBUG" ] ; then echo "RUN LEX2110071928" ; fi

sudo apt update

if ! sqlite_loc="$(type -p "sqlite3")" || [[ -z $sqlite_loc ]]; then
    echo "sqlite3 is missing. Install sqlite3 now?"
    # promptToContinue
    sudo apt -y install sqlite3
fi

if ! command -v jq &> /dev/null
then
    echo "jq is missing. Install jq now?"
    # promptToContinue
    sudo apt -y install jq
fi