#!/bin/bash
# Public MWMBashScript:
sqlite3 $MWCLI_CONFIG_DB_ON_HOSTING_SYSTEM "CREATE TABLE IF NOT EXISTS extensions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name text,
    localsettingsdirectives text
);"

writeToSystemLog "$MWCLI_CONFIG_DB initialized"