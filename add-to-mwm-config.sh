#!/bin/bash
# Public MWCLIBashScript: 
source ./my-system.env

if [ "`ls /home`" != "" ] ; then source ./lib/runInContainerOnly.sh ; fi

"php $MEDIAWIKI_CLI_IN_CONTAINER/lib/addToMWMSQLite.php \"ls\" \"
\\\$wgServer = 'https://p51:4443';
\""