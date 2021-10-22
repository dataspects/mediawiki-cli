#!/bin/bash
source /var/www/manage/lib/utils.sh

specialVersionLink () {
    printf "Check http://wiki.snoopy/wiki/Special:Version"
}

###############
# New extension
ext="LabeledSectionTransclusion"
/var/www/manage/manage-extensions/enable-extension.sh $ext
specialVersionLink
promptToContinue

/var/www/manage/manage-extensions/disable-extension.sh $ext
specialVersionLink
promptToContinue

####################
# Existing extension
ext="Mermaid"
/var/www/manage/manage-extensions/disable-extension.sh $ext
specialVersionLink
promptToContinue

/var/www/manage/manage-extensions/enable-extension.sh $ext
specialVersionLink
promptToContinue