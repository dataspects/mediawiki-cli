#!/bin/bash
# Public MWMBashScript:
/usr/bin/sqlite3 $CONFIG_DB_PATH "CREATE TABLE IF NOT EXISTS extensions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name text,
    localsettingsdirectives text
);"
echo "Initialized $CONFIG_DB_PATH"