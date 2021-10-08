#!/bin/bash

if [ -n "$DEBUG" ] ; then echo "RUN LEX2110080655" ; fi

export mwmLocalSettings="mwmLocalSettings.php"

initializemwmLocalSettings() {
    $CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "touch $mwmLocalSettings"
    writeToSystemLog "$mwmLocalSettings initialized"
}

export -f initializemwmLocalSettings

compileMWMLocalSettings() {
    $CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "php $MEDIAWIKI_CLI_IN_CONTAINER/lib/compileMWMLocalSettings.php"
    writeToSystemLog "Recompiled $mwmLocalSettings"
}

export -f compileMWMLocalSettings