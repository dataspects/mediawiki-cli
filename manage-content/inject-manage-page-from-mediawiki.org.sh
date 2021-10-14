#!/bin/bash
# Public MWCLIBashScript: Inject <TITLE>s from <WIKIAPI> BY <SECTION>s.

####################################

source ./lib/utils.sh

# ./manage-snapshots/take-restic-snapshot.sh BeforeMWOrgContentsInjection

WIKIAPI=https://www.mediawiki.org/w/api.php
TITLE="Help:Editing_pages"
SECTION=1
source ./manage-content/mediawiki-get-wikitext-from-api.sh

source ./lib/mediawiki-login-for-edit.sh
PAGENAME="Help:Editing pages"
source ./manage-content/mediawiki-inject.sh

runMWRunJobsPHP
runSMWRebuildData