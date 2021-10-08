#!/bin/bash
if [ "`ls /home`" != "" ] ; then source ./lib/runInContainerOnly.sh ; fi
source ./lib/utils.sh


php ./lib/updatemwmLocalSettings.php