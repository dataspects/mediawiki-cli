#!/bin/bash

source /home/lex/Canasta-DockerCompose/.env

sudo docker run \
    --rm -i --env-file /home/lex/Canasta-DockerCompose/.env \
    restic/restic \
    -r s3:$AWS_S3_API/$AWS_S3_BUCKET \
        check