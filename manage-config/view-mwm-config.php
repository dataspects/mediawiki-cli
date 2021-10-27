<?php
$database = "/var/www/config/mwmconfigdb.sqlite";
$db = new SQLite3($database);

if(isValidDatabase($db)) {
    $stmt = $db->prepare("SELECT localsettingsdirectives, name FROM extensions");
    $result = $stmt->execute();
    $mwmLocalSettingsString = "";
    while($res = $result->fetchArray(SQLITE3_ASSOC)){
        $mwmLocalSettingsString .= trim($res["name"])."\t".trim($res["localsettingsdirectives"])."\n";
    }
    print_r($mwmLocalSettingsString);
} else {
    printf("$database not found.\nInitialize with './manage-config/initialize-mwcliconfigdb.sh'\n");
}

function isValidDatabase($db) {
    $stmt = $db->prepare("SELECT name FROM sqlite_master WHERE type='table' AND name='extensions'");
    $result = $stmt->execute();
    if(is_array($result->fetchArray(SQLITE3_ASSOC))) {
        return true;
    }
    return false;
}