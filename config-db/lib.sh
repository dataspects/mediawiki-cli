#!/bin/bash

mwcliLocalSettings="mwcliLocalSettings.php"

initializeMWCLILocalSettings() {
    $CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "touch $mwcliLocalSettings"
    writeToSystemLog "$mwcliLocalSettings initialized"
}

compileMWCLILocalSettings() {
    $CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c "php ./lib/updateMWCLILocalSettings.php"
    writeToSystemLog "Recompiled $mwcliLocalSettings"
}