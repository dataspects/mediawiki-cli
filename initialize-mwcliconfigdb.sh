#!/bin/bash
# Public MWMBashScript:

source ./my-system.env

sqlite3 $MWCLI_CONFIG_DB "CREATE TABLE IF NOT EXISTS extensions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name text,
    localsettingsdirectives text
);"

writeToSystemLog "$MWCLI_CONFIG_DB initialized"