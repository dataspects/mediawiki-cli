<?php

require_once("/var/www/manage/manage-extensions/lib.php");

$extensionName = "LabeledSectionTransclusion";
prompt( "Testing $extensionName..." );
if(in_array(isLoadedFromExtensionsFolder($extensionName), array("folder present, not loaded", "folder not present, not loaded"))) {
    enableExtension($extensionName);
    prompt( "Enabled $extensionName..." );
} else {
    disableExtension($extensionName);
    prompt( "Disabled $extensionName..." );
}

$extensionName = "SemanticScribunto";
prompt( "Testing $extensionName..." );
if(isLoadedByComposer($extensionName) == "not loaded") {
    enableExtension($extensionName);
    prompt( "Enabled $extensionName..." );
} else {
    disableExtension($extensionName);
    prompt( "Disabled $extensionName..." );
}