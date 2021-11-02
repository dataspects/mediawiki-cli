<?php

require_once("/var/www/manage/manage-extensions/lib.php");

// echo "ASPECT 1: Extensions code present in /var/www/html/w/extensions:\n---\n";
$foldersInExtensionsFolder = array_diff(scandir("/var/www/html/w/extensions"), array('..', '.'));
sort($foldersInExtensionsFolder);
// echo implode(", ", array_diff(scandir("/var/www/html/w/extensions"), array('..', '.')));

// echo "\n\nASPECT 2: Extensions loaded by wfLoadExtension() in immutable /var/www/html/w/LocalSettings.php:\n---\n";
$containerInternalLocalSettingsArray = explode("\n", file_get_contents('/var/www/html/w/LocalSettings.php'));
$wfLoadExtensionStatements = getWfLoadExtensions($containerInternalLocalSettingsArray);
$requireExtensionStatements = getRequireExtensions($containerInternalLocalSettingsArray);
$sqliteLocalSettingsArray = explode("\n", file_get_contents('/var/www/config/mwmLocalSettings.php'));
$wfLoadExtensionStatements = array_merge($wfLoadExtensionStatements, getWfLoadExtensions($sqliteLocalSettingsArray));
$requireExtensionStatements = array_merge($requireExtensionStatements, getRequireExtensions($sqliteLocalSettingsArray));
$manualLocalSettingsArray = explode("\n", file_get_contents('/var/www/html/w/mwmLocalSettings_manual.php'));
$wfLoadExtensionStatements = array_merge($wfLoadExtensionStatements, getWfLoadExtensions($manualLocalSettingsArray));
$requireExtensionStatements = array_merge($requireExtensionStatements, getRequireExtensions($manualLocalSettingsArray));
sort($wfLoadExtensionStatements);
sort($requireExtensionStatements);
// echo implode(", ", $wfLoadExtensionStatements);

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

// echo "\n\nASPECT 5: Extensions reported by API:\n---\n";
$ch = curl_init();
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYSTATUS, false);
curl_setopt($ch, CURLOPT_URL, "http://localhost/w/api.php?action=query&meta=siteinfo&siprop=extensions&format=json");
$metaExtensions = json_decode(curl_exec($ch), true);
curl_close($ch);
$extensionsReportedByAPI = array();
foreach ($metaExtensions["query"]["extensions"] as $metaExtension) {
    $version = "";
    if(array_key_exists("version", $metaExtension)) {
        $version = $metaExtension["version"];
    }
    $extensionsReportedByAPI[] = $metaExtension["name"]." (".$version.")";
}
sort($extensionsReportedByAPI);
// echo implode(", ", $extensions);

// PRINT
if(!isset($doNotPrintMonitorTable)) {
    printf("Highlight by adding | egrep --color -i 'what you look for|wfLoadExtensions|---'\n");
    printf("\n");
    $headers = array("0-w/extensions/" => $foldersInExtensionsFolder, "1-wfLoadExtensions()" => $wfLoadExtensionStatements, "2-require" => $requireExtensionStatements, "3-composer.json" => $composerjsonReq, "4-composer.local.json" => $composerlocaljsonReq, "5-API" => $extensionsReportedByAPI);
    $numberOfAddedTabs = 3;
    foreach($headers as $header => $variable) {
        printf($header.str_repeat("\t", $numberOfAddedTabs));
    }
    printf("\n");
    foreach($headers as $header => $variable) {
        printf(str_repeat("-", strlen($header)).str_repeat("\t", $numberOfAddedTabs));
    }
    printf("\n");
    $tabWidth = 8;
    $manuallyAdded = 10;
    $continue = true;
    $x = 0;
    $maxLength = $numberOfAddedTabs * $tabWidth + $manuallyAdded;
    while ($continue) {
        $contCount = 0;
        foreach($headers as $header => $variable) {
            $headerRest = $tabWidth - strlen($header) % $tabWidth;
            $columnWidth = strlen($header) + $headerRest + ($numberOfAddedTabs * $tabWidth);
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
            // If the current aspect doesn't have a next element, then record this fact.
            if(!array_key_exists($x, $variable)) {
                $contCount++;
            }
        }
        // If in one loop none of the aspects have a next element, then stop.
        if($contCount == count($headers)){
            $continue = false;
        }
        $x++;
        printf("\n");
    }
}