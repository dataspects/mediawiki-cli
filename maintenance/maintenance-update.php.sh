#!/bin/bash
# Public MWMBashScript: Upgrade MWM System to new container image from https://hub.docker.com/r/dataspects/mediawiki/tags
cd /var/www/html/w && php maintenance/update.php --quick