<?php

$db = new SQLite3('mwcliconfigdb.sqlite');
$stmt = $db->prepare('SELECT localsettingsdirectives FROM extensions');
$result = $stmt->execute();

$mwcliLocalSettingsString = "";
while($res = $result->fetchArray(SQLITE3_ASSOC)){
    $mwcliLocalSettingsString .= trim($res["localsettingsdirectives"])."\n";
}

$mwcliLS = fopen("mwcliLocalSettings.php", "w");
fwrite($mwcliLS, "<?php\n".$mwcliLocalSettingsString);
fclose($mwcliLS);