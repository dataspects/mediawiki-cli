#!/bin/bash

CATALOGUE_URL=https://raw.githubusercontent.com/dataspects/mediawiki-cli/main/catalogues/extensions.json

# https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/
# https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4

getExtensionJSON () {
    catalogueJSON=$(curl -S \
        $OPTION_INSECURE \
        --silent \
        --retry 2 \
        --retry-delay 5\
        --user-agent "Curl Shell Script" \
        --keepalive-time 60 \
        --header "Accept-Language: en-us" \
        --header "Connection: keep-alive" \
        --compressed \
        --request "GET" "${CATALOGUE_URL}")
}