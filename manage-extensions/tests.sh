#!/bin/bash
if [ "`ls /home`" != "" ] ; then source ./lib/runInContainerOnly.sh ; fi=false
source ./lib/utils.sh
source ./my-system.env

specialVersionLink () {
    printf "Check http://wiki.snoopy/wiki/Special:Version"
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