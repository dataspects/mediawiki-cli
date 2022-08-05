#!/bin/bash

sudo docker exec -it \
    $(basename $(tr [A-Z] [a-z] <<< "$CANASTA_ROOT"))_web_1 \
    /bin/bash -c "php maintenance/runJobs.php && php canasta-extensions/SemanticMediaWiki/maintenance/rebuildData.php"
