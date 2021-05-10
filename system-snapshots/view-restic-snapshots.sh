#!/bin/bash
# Public MWCLIBashScript: View system snapshots.

source ./lib/runInContainerOnly.sh

printf "\n\033[0;32m\e[1mMWCLI System Snapshots\033[0m"
printf "\n====================\n"
restic \
    --repo $SYSTEM_SNAPSHOT_FOLDER_IN_CONTAINER \
    --password-file $RESTIC_PASSWORD_IN_CONTAINER \
        snapshots
printf "\n====================\n\n"
printf "To take a snapshot run : ./system-snapshots/take-restic-snapshot.sh <TAG>\n"
printf "To restore <ID> run : ./system-snapshots/restore-restic-snapshot.sh <ID>\n"
printf "\n"

