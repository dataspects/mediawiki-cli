<?php
$db = new SQLite3("/var/www/html/mwmconfigdb.sqlite");

$name  = $argv[1];
$stmt = $db->prepare("DELETE FROM extensions WHERE name=:name");
$stmt->bindValue(":name", $name, SQLITE3_TEXT);

$stmt->execute();