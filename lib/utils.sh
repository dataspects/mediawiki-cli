#!/bin/bash

if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080657" ; fi

# Public MWCLIBashFunction
promptToContinue () {
    printf "\n\n\e[2m"
    read -p "Continue? (y/n)" -n 1 -r
    printf "\e[0m"
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        printf "\n"
        exit 1
    fi
    printf "\n"
}

export -f promptToContinue

# CURL utils
OPTION_INSECURE=--insecure
cookie_jar="wikicj"
folder="/tmp"

getPageData () {
    PAGENAME=$(sed -r 's/.*\/(.*).wikitext/\1/g' <<< $1)
    WIKITEXT=`cat "$1"`
}

# Public MWCLIBashFunction
runMWRunJobsPHP () {
    if [ "`ls /home`" != "" ]
    then
        $CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "cd w; php maintenance/runJobs.php"
    else
        cd w; php maintenance/runJobs.php --quick
    fi
}

# Public MWCLIBashFunction
runMWUpdatePHP () {
    if [ "`ls /home`" != "" ]
    then
        $CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "cd w; php maintenance/update.php --quick"
    else
        cd w; php maintenance/update.php --quick
    fi
}

export -f runMWUpdatePHP

# Public MWCLIBashFunction
runSMWRebuildData () {
    if [ "`ls /home`" != "" ]
    then
        $CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "cd w; php extensions/SemanticMediaWiki/maintenance/rebuildData.php"
    else
        cd w; php extensions/SemanticMediaWiki/maintenance/rebuildData.php
    fi
}