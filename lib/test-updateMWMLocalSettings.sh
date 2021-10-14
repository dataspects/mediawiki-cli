#!/bin/bash
if [ "`ls /home`" != "" ] ; then source ./lib/runInContainerOnly.sh ; fi
source ./lib/utils.sh


php /var/www/manage/mediawiki-cli/manage-config/updatemwmLocalSettings.php