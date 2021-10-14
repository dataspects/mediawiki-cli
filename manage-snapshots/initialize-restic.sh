#!/bin/bash
# Public MWMBashScript: Check out primary system aspects.

restic -r s3:$AWS_S3_API/$AWS_S3_BUCKET init