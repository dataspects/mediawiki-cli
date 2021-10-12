<?php
$db = new SQLite3("/var/www/html/mwmconfigdb.sqlite");
$stmt = $db->prepare("SELECT localsettingsdirectives, name FROM extensions");
$result = $stmt->execute();
$mwmLocalSettingsString = "";
while($res = $result->fetchArray(SQLITE3_ASSOC)){
    $mwmLocalSettingsString .= trim($res["name"])."\t".trim($res["localsettingsdirectives"])."\n";
}
print_r($mwmLocalSettingsString);
