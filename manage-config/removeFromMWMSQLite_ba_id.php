<?php
$db = new SQLite3("/var/www/config/mwmconfigdb.sqlite");

$id  = $argv[1];
$stmt = $db->prepare("DELETE FROM extensions WHERE id=:id");
$stmt->bindValue(":id", $id, SQLITE3_TEXT);

$stmt->execute();