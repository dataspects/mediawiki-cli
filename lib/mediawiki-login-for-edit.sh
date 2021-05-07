#!/bin/bash

# CreateCampEMWCon2021: https://mwstake.org/mwstake/wiki/MWStake_MediaWiki_Manager/ContentManagement

source ./my-system.env

source ./lib/utils.sh

WIKI=https://$SYSTEM_DOMAIN_NAME:4443/w
WIKIAPI=https://$SYSTEM_DOMAIN_NAME:4443/w/api.php

CR=$(curl -S \
    $OPTION_INSECURE \
	--location \
	--silent \
	--retry 2 \
	--retry-delay 5\
	--cookie $cookie_jar \
	--cookie-jar $cookie_jar \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--request "GET" "${WIKIAPI}?action=query&meta=tokens&type=login&format=json")

rm ${folder}/login.json
echo "$CR" > ${folder}/login.json
TOKEN=$(jq --raw-output '.query.tokens.logintoken'  ${folder}/login.json)
if [ "$TOKEN" == "null" ]; then
	echo "Getting a login token failed."
	exit
fi

CR=$(curl -S \
    $OPTION_INSECURE \
	--location \
	--silent \
	--cookie $cookie_jar \
    --cookie-jar $cookie_jar \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--data-urlencode "username=$WIKI_ADMIN_USERNAME" \
	--data-urlencode "password=$WIKI_ADMIN_PASSWORD" \
	--data-urlencode "rememberMe=1" \
	--data-urlencode "logintoken=$TOKEN" \
	--data-urlencode "loginreturnurl=$WIKI" \
	--request "POST" "$WIKIAPI?action=clientlogin&format=json")

STATUS=$(echo $CR | jq '.clientlogin.status')
if [[ $STATUS == *"PASS"* ]]; then
	echo "SUCCESS: logged in as $WIKI_ADMIN_USERNAME."
	echo "-----"
else
	echo "Unable to login $WIKI_ADMIN_USERNAME, is logintoken ${TOKEN} correct?"
	exit
fi

CR=$(curl -S \
    $OPTION_INSECURE \
	--location \
    --silent \
	--cookie $cookie_jar \
	--cookie-jar $cookie_jar \
	--user-agent "Curl Shell Script" \
	--keepalive-time 60 \
	--header "Accept-Language: en-us" \
	--header "Connection: keep-alive" \
	--compressed \
	--request "GET" "${WIKIAPI}?action=query&meta=tokens&type=csrf&format=json")

echo "$CR" > ${folder}/edittoken.json
EDITTOKEN=$(jq --raw-output '.query.tokens.csrftoken' ${folder}/edittoken.json)
rm ${folder}/edittoken.json

if ! [[ $EDITTOKEN == *"+\\"* ]]; then
	echo "Edit token not set."
	exit
fi
