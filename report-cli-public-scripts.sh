#!/bin/bash

clear;

FLAGS="--recursive \
    --initial-tab \
    --after-context=0 \
    --color=always \
    --exclude=report-cli-public-scripts.sh \
    --exclude-dir=mediawiki_root \
    --exclude-dir=mariadb_data \
    --exclude-dir=currentresources \
    --exclude-dir=.git"

egrep $FLAGS "# Public MWCLIBashScript"