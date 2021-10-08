#!/bin/bash
# Public MWMBashScript: Check out primary system aspects.
clear;
set -a
    source ./my-system.env
set +a
if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080738" ; fi

$CONTAINER_COMMAND exec -it --env-file=./my-system.env \
    $MEDIAWIKI_CONTAINER_NAME \
    /bin/bash