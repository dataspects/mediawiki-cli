<?php

function getWfLoadExtensions($lines) {
    $wfLEs = array();
    foreach($lines as $lsline) {
        preg_match('/#?wfLoadExtension\( *["\']+(.*)["\']+ *\);/', $lsline, $matches);
        if(count($matches) > 0) {
            $wfLEs[] = trim($matches[1]);
        };
    }
    return $wfLEs;
}

// echo "ASPECT 1: Extensions code present in /var/www/html/w/extensions:\n---\n";
$folders = array_diff(scandir("/var/www/html/w/extensions"), array('..', '.'));
sort($folders);
// echo implode(", ", array_diff(scandir("/var/www/html/w/extensions"), array('..', '.')));

// echo "\n\nASPECT 2: Extensions loaded by wfLoadExtension() in immutable /var/www/html/w/LocalSettings.php:\n---\n";
$localSettingsArray = explode("\n", file_get_contents('/var/www/html/w/LocalSettings.php'));
$wfLEs = getWfLoadExtensions($localSettingsArray);
sort($wfLEs);
// echo implode(", ", $wfLEs);

// echo "\n\nASPECT 3: Extensions loaded by immutable /var/www/html/w/composer.json:\n---\n";
$composerjsonArray = json_decode(file_get_contents('/var/www/html/w/composer.json'), true);
$composerjsonReq = array();
foreach($composerjsonArray["require"] as $ext => $version) {
    $composerjsonReq[] = $ext." (".$version.")";
}
sort($composerjsonReq);
// echo implode(", ", $composerjsonReq);

// echo "\n\nASPECT 4: Extensions loaded by mutable /var/www/html/w/composer.local.json:\n---\n";
$composerjsonArray = json_decode(file_get_contents('/var/www/html/w/composer.local.json'), true);
$composerlocaljsonReq = array();
foreach($composerjsonArray["require"] as $ext => $version) {
    $composerlocaljsonReq[] = $ext." (".$version.")";
}
sort($composerlocaljsonReq);
// echo implode(", ", $composerlocaljsonReq);

// echo "\n\nASPECT 5: Extensions loaded by compiled /var/www/config/mwmLocalSettings.php:\n---\n";
$lines = explode("\n", file_get_contents('/var/www/config/mwmLocalSettings.php'));
$wfLEs2 = getWfLoadExtensions($lines);
sort($wfLEs2);
// echo implode(", ", $wfLEs2);

// echo "\n\nASPECT 6: Extensions managed by /var/www/config/mwmconfigdb.sqlite:\n---\n";
$db = new SQLite3("/var/www/config/mwmconfigdb.sqlite");
$stmt = $db->prepare("SELECT localsettingsdirectives, name FROM extensions");
$result = $stmt->execute();
$mwmLocalSettingsString = [];
while($res = $result->fetchArray(SQLITE3_ASSOC)){
    $mwmLocalSettingsString[] = trim($res["name"]);
}
// print_r($mwmLocalSettingsString);

// echo "\n\nASPECT 7: Extensions reported by API:\n---\n";
$ch = curl_init();
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYSTATUS, false);
curl_setopt($ch, CURLOPT_URL, "http://localhost/w/api.php?action=query&meta=siteinfo&siprop=extensions&format=json");
$metaExtensions = json_decode(curl_exec($ch), true);
curl_close($ch);
$extensions = array();
foreach ($metaExtensions["query"]["extensions"] as $metaExtension) {
    $version = "";
    if(array_key_exists("version", $metaExtension)) {
        $version = $metaExtension["version"];
    }
    $extensions[] = $metaExtension["name"]." (".$version.")";
}
sort($extensions);
// echo implode(", ", $extensions);

// PRINT
printf("\n");
$headers = array("w/extensions/" => $folders, "wfLoadExtensions()" => $wfLEs, "composer.json" => $composerjsonReq, "composer.local.json" => $composerlocaljsonReq, "mwmLocalSettings.php" => $wfLEs2, "mwmconfigdb.sqlite" => $mwmLocalSettingsString, "API" => $extensions);
foreach($headers as $header => $variable) {
    printf($header."\t\t");
}
printf("\n");
foreach($headers as $header => $variable) {
    printf(str_repeat("-", strlen($header))."\t\t");
}
printf("\n");
$maxLength = 22;
$tabWidth = 8;
for ($x = 0; $x <= 60; $x++) {
    foreach($headers as $header => $variable) {
        $headerRest = $tabWidth - strlen($header) % $tabWidth;
        $columnWidth = strlen($header) + $headerRest + (2 * $tabWidth);
        if(array_key_exists($x, $variable)) {
            $ss = substr($variable[$x], 0, $maxLength);
            $tsToAdd = floor(($columnWidth - strlen($ss)) / $tabWidth);
            $mod = ($columnWidth - strlen($ss)) % $tabWidth;
            if($mod > 0) {
                printf($ss.str_repeat("\t", $tsToAdd ));
            } else {
                printf($ss.str_repeat("\t", $tsToAdd - 1 ));
            }
        } else {
            printf(str_repeat("\t", $columnWidth / $tabWidth - 1));
        }
    }
    printf("\n");
}
printf("\n");