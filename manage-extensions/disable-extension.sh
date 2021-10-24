    #!/bin/bash
    # Public MWCLIBashScript: Disable extensions selected from $CATALOGUE_URL.
    # https://cameronnokes.com/blog/working-with-json-in-bash-using-jq/
    # https://edoras.sdsu.edu/doc/sed-oneliners.html

    EXTNAME=$1

    /var/www/manage/manage-snapshots/take-restic-snapshot.sh BeforeDisabling-$EXTNAME

    php /var/www/manage/manage-extensions/disable-extension.php $EXTNAME
    
    runMWUpdatePHP