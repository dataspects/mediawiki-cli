#!/bin/bash
# Public MWCLIBashScript: Check the usage of distinct MWCLI CLI-level directives (scripts, functions, PHP).

strs=(
    "runMWUpdatePHP"
    "runSMWRebuildData"
    "waitForMariaDB"
    "$CONTAINER_COMMAND pod"
    "./manage-snapshots/take-restic-snapshot.sh"
    "addToMWCLISQLite.php"
    "removeFromMWCLISQLite.php"
    "updatemwmLocalSettings.php"
    "composer.phar"
)

clear;
if [[ $1 == "" ]]
then
    CONTEXT=0
else
    CONTEXT=$1
fi
FLAGS="--line-number \
    --recursive \
    --color=always \
    --ignore-case \
    --context=$CONTEXT \
    --exclude-dir=develop-system \
    --exclude-dir=system_root \
    --exclude-dir=mariadb_data \
    --exclude-dir=currentresources \
    --exclude-dir=.git"

for s in "${strs[@]}"
do
    printf "\n\n\n=== '$s' found in ===\n"
    egrep $FLAGS "$s";
done