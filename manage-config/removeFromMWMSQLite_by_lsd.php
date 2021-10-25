<?php
require_once("/var/www/manage/manage-config/lib.php");

$lsd  = $argv[1];
removeFromMWMSQLite_by_lsd($lsd);