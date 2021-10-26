<?php
require_once("/var/www/manage/manage-config/lib.php");

$fileName  = $argv[1];

if ($file = fopen($fileName, "r")) {
    while(!feof($file)) {
        $textperline = fgets($file);
         echo $textperline;
     }
    fclose($file);
}
#addListToMWMSQLite($name, $lsd);