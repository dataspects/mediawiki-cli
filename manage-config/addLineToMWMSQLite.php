<?php
require_once("/var/www/manage/manage-config/lib.php");

$name  = $argv[1];
$lsd  = $argv[2];
addLineToMWMSQLite($name, $lsd);