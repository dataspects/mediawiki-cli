#!/bin/bash
# Public MWMBashScript: Check out primary system aspects.

restic --password-file /var/www/restic_password --verbose init --repo /var/www/snapshots