#!/bin/bash

# CreateCampEMWCon2021: https://mwstake.org/mwstake/wiki/MWStake_MediaWiki_Manager/Infrastructure
source ./my-system.env
if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080554" ; fi

if [ "`ls /home`" != "" ]
then
    if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080556 in $MEDIAWIKI_CONTAINER_NAME:$MEDIAWIKI_CLI_IN_CONTAINER" ; fi
    
    # source ./lib/utils.sh
    if [ -n "$DEBUG" ] ; then printf "INFO: \x1b[31mredirecting run command to \033[1m$CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME $MEDIAWIKI_CLI_IN_CONTAINER/`dirname $0`/`basename $0` "$1"\n" ; fi

    $CONTAINER_COMMAND exec --env-file=./my-system.env $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "$MEDIAWIKI_CLI_IN_CONTAINER/`dirname $0`/`basename $0` $1"
    exit
fi