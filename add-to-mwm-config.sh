#!/bin/bash
# Public MWCLIBashScript: 
source ./my-system.env

if [ "`ls /home`" != "" ] ; then source ./lib/runInContainerOnly.sh ; fi

"php /var/www/manage/lib/addToMWMSQLite.php \"ls\" \"
\\\$wgServer = 'https://p51:4443';
\""