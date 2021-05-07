<?php
$name  = $argv[1];
$db = new SQLite3('mwcliconfigdb.sqlite');

$stmt = $db->prepare('DELETE FROM extensions WHERE name=:name');
$stmt->bindValue(':name', $name, SQLITE3_TEXT);

$stmt->execute();