#!/bin/bash
# Public MWMBashScript: Check out primary system aspects.
clear;
source ./my-system.env
if $DEBUG ; then echo "RUN LEX2110080552" ; fi

./config-db/view-mwm-config.sh
./manage-system/show-composerLocalJSON.sh
./system-snapshots/view-restic-snapshots.sh
./manage-extensions/show-extension-catalogue.sh
# ./report-podman.sh