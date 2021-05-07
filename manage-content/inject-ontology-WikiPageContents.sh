#!/bin/bash
# Public MWCLIBashScript: Inject objects from GitHub <ONTOLOGY_URL>.

source ./my-system.env
source ./lib/utils.sh

# Ask user
echo -n "Enter full GitHub clone URL, e.g. 'https://github.com/dataspects/dataspectsSystemCoreOntology.git': "
read ONTOLOGY_URL

./system-snapshots/take-restic-snapshot.sh BeforeGitHubOntologyContentsInjection

# Clone
mkdir -p ontologies
ONTOLOGY_NAME=`basename $ONTOLOGY_URL .git`
git clone $ONTOLOGY_URL ontologies/$ONTOLOGY_NAME

# Log in to MW
source ./lib/mediawiki-login-for-edit.sh

# Inject
for filename in ontologies/$ONTOLOGY_NAME/objects/*; do
    if [[ -d $filename ]]; then
        NAMESPACE=$(sed -r 's/.*\/(.*)/\1/g' <<< $filename)
        for filename2 in $filename/*; do
            getPageData "$filename2"
            PAGENAME=$NAMESPACE:$PAGENAME
            source ./manage-content/mediawiki-inject.sh
        done
    else
        getPageData "$filename"
        source ./manage-content/mediawiki-inject.sh
    fi    
done

runMWRunJobsPHP
runSMWRebuildData