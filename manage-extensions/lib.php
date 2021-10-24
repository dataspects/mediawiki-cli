<?php

// $foldersInExtensionsFolder;
// $wfLoadExtensionStatements;
// $requireExtensionStatements;
// $composerjsonReq;
// $composerlocaljsonReq;
// $wfLoadExtensionStatements2;
// $mwmLocalSettingsString;
// $extensionsReportedByAPI;

function getWfLoadExtensions($lines) {
    $wfLoadExtensionStatements = array();
    foreach($lines as $lsline) {
        preg_match('/#?wfLoadExtension\( *["\']+(.*)["\']+ *\);/', $lsline, $matches);
        if(count($matches) > 0) {
            $wfLoadExtensionStatements[] = trim($matches[1]);
        };
    }
    return $wfLoadExtensionStatements;
}

function getRequireExtensions($lines) {
    $wfLoadExtensionStatements = array();
    foreach($lines as $lsline) {
        preg_match('/#?require.+\/extensions\/(.+)\/.+;/', $lsline, $matches);
        if(count($matches) > 0) {
            $wfLoadExtensionStatements[] = trim($matches[1]);
        };
    }
    return $wfLoadExtensionStatements;
}

function isLoadedFromExtensionsFolder($extensionName) {
    $doNotPrintMonitorTable = true;
    require("/var/www/manage/manage-extensions/monitor.php");
    if(in_array($extensionName, $foldersInExtensionsFolder)) {
        if(in_array($extensionName, $wfLoadExtensionStatements) OR in_array($extensionName, $requireExtensionStatements) OR in_array($extensionName, $mwmLocalSettingsString)) {
            if(in_array($extensionName, $wfLoadExtensionStatements) XOR in_array($extensionName, $requireExtensionStatements) XOR in_array($extensionName, $mwmLocalSettingsString)) {
                return "properly loaded";
            }
            return "not properly loaded";
        }
        return "folder present, not loaded";
    }
    return "folder not present, not loaded";
}

function isLoadedByComposer($extensionName) {
    $doNotPrintMonitorTable = true;
    require("/var/www/manage/manage-extensions/monitor.php");
    $installationAspects = getInstallationAspects($extensionName);
    if(in_array($installationAspects->composer." (".$installationAspects->version.")", $composerjsonReq) OR in_array($installationAspects->composer." (".$installationAspects->version.")", $composerlocaljsonReq)) {
        return "loaded";
    }
    return "not loaded";
}

function getExtensionJSON() {
    $catalogueURL = "https://raw.githubusercontent.com/dataspects/mediawiki-cli/main/catalogues/extensions.json";
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYSTATUS, false);
    curl_setopt($ch, CURLOPT_URL, $catalogueURL);
    $extensionsCatalogue = json_decode(curl_exec($ch));
    curl_close($ch);
    return $extensionsCatalogue;
}

function getInstallationAspects($extensionName) {
    $extensionsCatalogue = getExtensionJSON();
    $key = array_search($extensionName, array_column($extensionsCatalogue, "name"));
    return $extensionsCatalogue[$key]->{"installation-aspects"};
}

function addToMWMSQLite($name, $localsettingsdirectives) {
    $db = new SQLite3("/var/www/config/mwmconfigdb.sqlite");
    $stmt = $db->prepare("INSERT INTO extensions (name, localsettingsdirectives) VALUES ( :name, :localsettingsdirectives)");
    $stmt->bindValue(":name", trim($name), SQLITE3_TEXT);
    $stmt->bindValue(":localsettingsdirectives", trim($localsettingsdirectives), SQLITE3_TEXT);
    $stmt->execute();
}

function removeFromMWMSQLite_by_lsd($localsettingsdirectives) {
    $db = new SQLite3("/var/www/config/mwmconfigdb.sqlite");
    $stmt = $db->prepare("DELETE FROM extensions WHERE localsettingsdirectives=:localsettingsdirectives");
    $stmt->bindValue(":localsettingsdirectives", trim($localsettingsdirectives), SQLITE3_TEXT);
    $stmt->execute();
}

function enableExtension($extensionName) {
    $installationAspects = getInstallationAspects($extensionName);
    if(property_exists($installationAspects, "repository")) {
        $path = "/var/www/html/w/extensions/$extensionName";
        if ( !file_exists( $path ) && !is_dir( $path ) ) {
            `git clone $installationAspects->repository $path`;
        } 
    }
    if(property_exists($installationAspects, "localsettings")) {
        foreach($installationAspects->localsettings as $lsd) {
            addToMWMSQLite($extensionName, $lsd);
        }
        compileMWMLocalSettings();
    }
    if(property_exists($installationAspects, "composer")) {
        `echo $(cat /var/www/html/w/composer.local.json | jq ".require += { \"$installationAspects->composer\": \"$installationAspects->version\"}") > /var/www/html/w/composer.local.json`;
        `cd /var/www/html/w && COMPOSER=composer.json COMPOSER_HOME=/var/www/html/w php composer.phar update`;
    }
}

function disableExtension($extensionName) {
    $installationAspects = getInstallationAspects($extensionName);
    if(property_exists($installationAspects, "localsettings")) {
        foreach($installationAspects->localsettings as $lsd) {
            removeFromMWMSQLite_by_lsd($lsd);
        }
        compileMWMLocalSettings();
    }
    if(property_exists($installationAspects, "composer")) {
        `echo $(cat /var/www/html/w/composer.local.json | jq "del(.require.\"$installationAspects->composer\")") > /var/www/html/w/composer.local.json`;
        `cd /var/www/html/w && COMPOSER=composer.json COMPOSER_HOME=/var/www/html/w php composer.phar update`;
    }
}

function compileMWMLocalSettings() {
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
}

function prompt( $msg ) 
{ 
    echo $msg . "\n";
    $in = trim( fgets( STDIN )); 
    return $in; 
} 