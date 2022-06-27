#!/bin/bash

sudo docker exec -it \
    $(basename $CANASTA_ROOT)_web_1 \
    /bin/bash -c "php maintenance/update.php && php maintenance/runJobs.php && php canasta-extensions/SemanticMediaWiki/maintenance/rebuildData.php"