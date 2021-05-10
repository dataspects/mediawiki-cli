#!/bin/bash

export mwmLocalSettings="mwmLocalSettings.php"

initializemwmLocalSettings() {
    $CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "touch $mwmLocalSettings"
    writeToSystemLog "$mwmLocalSettings initialized"
}

export -f initializemwmLocalSettings

compilemwmLocalSettings() {
    $CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "php $MEDIAWIKI_CLI_IN_CONTAINER/lib/updateMWMLocalSettings.php"
    writeToSystemLog "Recompiled $mwmLocalSettings"
}

export -f compilemwmLocalSettings