#!/bin/bash
source ./lib/runInContainerOnly.sh=false
source ./lib/utils.sh
source ./my-system.env

specialVersionLink () {
    printf "Check https://$SYSTEM_DOMAIN_NAME:4443/wiki/Special:Version"
}

###############
# New extension
ext="LabeledSectionTransclusion"
./manage-extensions/enable-extension.sh $ext
specialVersionLink
promptToContinue

./manage-extensions/disable-extension.sh $ext
specialVersionLink
promptToContinue

####################
# Existing extension
ext="Mermaid"
./manage-extensions/disable-extension.sh $ext
specialVersionLink
promptToContinue

./manage-extensions/enable-extension.sh $ext
specialVersionLink
promptToContinue