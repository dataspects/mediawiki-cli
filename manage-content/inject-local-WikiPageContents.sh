#!/bin/bash
# Public MWCLIBashScript: Inject <PageName>.wikitext files from local ./WikiPageContents directory.

source ./my-system.env

####################################

source ./lib/utils.sh

# ./system-snapshots/take-restic-snapshot.sh BeforeLocalContentsInjection

source ./lib/mediawiki-login-for-edit.sh

for filename in WikiPageContents/*.wikitext; do
    getPageData "$filename"
    source ./manage-content/mediawiki-inject.sh
done

runMWRunJobsPHP
runSMWRebuildData