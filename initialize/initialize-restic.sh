#!/bin/bash
# Public MWMBashScript: Check out primary system aspects.

source ./my-system.env

$CONTAINER_COMMAND exec $MEDIAWIKI_CONTAINER_NAME /bin/bash -c \
  "restic --password-file $RESTIC_PASSWORD_IN_CONTAINER --verbose init --repo $SYSTEM_SNAPSHOT_FOLDER_IN_CONTAINER"