#!/bin/bash
# Public MWCLIBashScript: View system snapshots.

printf "\n\033[0;32m\e[1mMWCLI System Snapshots\033[0m"
printf "\n======================\n"

restic -r s3:$AWS_S3_API/$AWS_S3_BUCKET snapshots

printf "\n====================\n\n"
printf "To take a snapshot run : ./system-snapshots/take-restic-snapshot.sh <TAG>\n"
printf "To restore <ID> run : ./system-snapshots/restore-restic-snapshot.sh <ID>\n"
printf "\n"

# Minio
#######

