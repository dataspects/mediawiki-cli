#!/bin/bash
# Public MWMBashScript:
PATH=/var/www/html/mwmconfigdb.sqlite
/usr/bin/sqlite3 $PATH "CREATE TABLE IF NOT EXISTS extensions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name text,
    localsettingsdirectives text
);"
echo "Initialized $PATH"