<?php

function addToMWMSQLite($name, $localsettingsdirectives) {
    $db = new SQLite3("/var/www/config/mwmconfigdb.sqlite");
    $stmt = $db->prepare("INSERT INTO extensions (name, localsettingsdirectives) VALUES ( :name, :localsettingsdirectives)");
    $stmt->bindValue(":name", trim($name), SQLITE3_TEXT);
    $stmt->bindValue(":localsettingsdirectives", trim($localsettingsdirectives), SQLITE3_TEXT);
    $stmt->execute();
}

function removeFromMWMSQLite_by_lsd($localsettingsdirectives) {
    $db = new SQLite3("/var/www/config/mwmconfigdb.sqlite");
    $stmt = $db->prepare("DELETE FROM extensions WHERE localsettingsdirectives=:localsettingsdirectives");
    $stmt->bindValue(":localsettingsdirectives", trim($localsettingsdirectives), SQLITE3_TEXT);
    $stmt->execute();
}
