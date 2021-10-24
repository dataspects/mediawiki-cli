#!/bin/bash
# Public MWCLIBashScript: Inject objects from GitHub <ONTOLOGY_URL>.

source ./lib/utils.sh

# Ask user
echo -n "Enter full GitHub clone URL, e.g. 'https://github.com/dataspects/dataspectsSystemCoreOntology.git': "
read ONTOLOGY_URL

/var/www/manage/manage-snapshots/take-restic-snapshot.sh BeforeGitHubOntologyContentsInjection

# Clone
mkdir -p /tmp/ontologies
ONTOLOGY_NAME=`basename $ONTOLOGY_URL .git`
git clone $ONTOLOGY_URL /tmp/ontologies/$ONTOLOGY_NAME

# Log in to MW
source ./lib/mediawiki-login-for-edit.sh

# Inject
for filename in /tmp/ontologies/$ONTOLOGY_NAME/objects/*; do
    if [[ -d $filename ]]; then
        NAMESPACE=$(sed -r 's/.*\/(.*)/\1/g' <<< $filename)
        for filename2 in $filename/*; do
            getPageData "$filename2"
            PAGENAME=$NAMESPACE:$PAGENAME
            source /var/www/manage/manage-content/mediawiki-inject.sh
        done
    else
        getPageData "$filename"
        source /var/www/manage/manage-content/mediawiki-inject.sh
    fi    
done

runMWRunJobsPHP
runSMWRebuildData