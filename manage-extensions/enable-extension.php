<?php

require_once("/var/www/manage/manage-extensions/lib.php");

$extensionName  = $argv[1];
enableExtension($extensionName);
