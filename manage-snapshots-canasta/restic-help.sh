#!/bin/bash
# Public MWCLIBashScript: Restore system snapshot.

sudo docker run \
    --rm -i \
    restic/restic \
        --help