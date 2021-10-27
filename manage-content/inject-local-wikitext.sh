#!/bin/bash
# Public MWCLIBashScript: Inject <PageName>.wikitext files from local ./WikiPageContents directory.

####################################

if [[ -z "$1" ]]; then
  echo 'You must provide a directory path containing *.wikitext files as $1!'
  exit
fi

source ./lib/utils.sh

# ./manage-snapshots/take-restic-snapshot.sh BeforeLocalContentsInjection

source ./lib/mediawiki-login-for-edit.sh

for filename in $1/*.wikitext; do
    getPageData "$filename"
    source ./manage-content/mediawiki-inject.sh
done

runMWRunJobsPHP
runSMWRebuildData