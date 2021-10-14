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
    php /var/www/html/w/maintenance/runJobs.php --quick
}

# Public MWCLIBashFunction
runMWUpdatePHP () {
    php /var/www/html/w/maintenance/update.php --quick
}

export -f runMWUpdatePHP

# Public MWCLIBashFunction
runSMWRebuildData () {
    php /var/www/html/w/extensions/SemanticMediaWiki/maintenance/rebuildData.php
}