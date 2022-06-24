#!/bin/bash

sudo docker run \
    --rm -i --env-file .env \
    restic/restic \
    -r s3:$AWS_S3_API/$AWS_S3_BUCKET \
        init