<?php
shell_exec('pwd');
$db = new SQLite3("/var/www/config/mwmconfigdb.sqlite");
$stmt = $db->prepare("SELECT localsettingsdirectives FROM extensions");
$result = $stmt->execute();

$mwmLocalSettingsString = "";
while($res = $result->fetchArray(SQLITE3_ASSOC)){
    $mwmLocalSettingsString .= trim($res["localsettingsdirectives"])."\n";
}

$mwcliLS = fopen("/var/www/config/mwmLocalSettings.php", "w");
fwrite($mwcliLS, "<?php\n".$mwmLocalSettingsString);
fclose($mwcliLS);