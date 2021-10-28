# dataspects mediawiki-cli

* dataspects mediawiki-cli is is a tool set for managing MediaWiki instances on [dataspects Snoopy](https://github.com/dataspects/snoopy).
* `mediawiki-cli` is exclusively used through [`dataspects/mediawiki`](https://hub.docker.com/r/dataspects/mediawiki) container images.
* *For a development setup, see `mediawiki-cli production/development volume` in `templates/docker-compose.yml`.*

## Concepts

| Aspect |   |
| ------ | - |
| `docker-compose.yml` | See `templates/docker-compose.yml` for<ul><li>**environment variables**</li><li>**persistent volumes/mounts**</li></ul> |
| `/var/www/config/` | <ol><li>The container's `/var/www/html/w/LocalSettings.php` is immutable/ephemeral.</li><li>All **CLI-managed** `LocalSettings.php` customizations are added to `/var/www/config/mwmconfigdb.sqlite` on a per-line basis. `/var/www/config/mwmconfigdb.sqlite` is then compiled into `/var/www/config/mwmLocalSettings.php` which is [required by `/var/www/html/w/LocalSettings.php` at the end <u>**but before**</u> mwmLocalSettings_manual.php](https://github.com/dataspects/dataspectsSystemBuilder/blob/master/docker-images/mediawiki/require_customizations.sh).<br/>&rarr; *This covers settings that **enable** features/extensions/functionality.*</li><li>All **manual** `LocalSettings.php` customizations are managed in `/var/www/config/mwmLocalSettings_manual.php` which is [required by `/var/www/html/w/LocalSettings.php` <u>**at the very end**</u>](https://github.com/dataspects/dataspectsSystemBuilder/blob/master/docker-images/mediawiki/require_customizations.sh).<br/>&rarr; *This covers settings that **configure** features/extensions/functionality.*</li><ol> |

## Features

| In `docker exec -it --workdir /var/www/manage/ <WIKI_CONTAINER_NAME> /bin/bash` run... | Purpose |
| ---------------------------------------------- | ------- |
| `./status.sh` | Status report |
| `php ./manage-config/view-mwm-config.php` | Check LocalSettings.php customizations (see Concepts below) |
| `./manage-extensions/show-extension-catalogue.sh` | View [MWStake-certified extensions](https://raw.githubusercontent.com/dataspects/mediawiki-cli/main/catalogues/extensions.json) |
| `./manage-extensions/enable-extension.sh <EXTENSION_NAME>` | **<span style="color: red">!</span>** Enable [MWStake-certified extensions](https://raw.githubusercontent.com/dataspects/mediawiki-cli/main/catalogues/extensions.json) |
| `./manage-extensions/disable-extension.sh  <EXTENSION_NAME>` | **<span style="color: red">!</span>** Disable [MWStake-certified extensions](https://raw.githubusercontent.com/dataspects/mediawiki-cli/main/catalogues/extensions.json) |
| `./manage-content/inject-ontology-WikiPageContents.sh` | **<span style="color: red">!</span>** Inject content from a repository ([example](https://github.com/dataspects/dataspectsSystemCoreOntology)) |
| `php manage-extensions/monitor.php` | View extensions installation aspects |
| `./manage-content/inject-local-wikitext.sh` | **<span style="color: red">!</span>** Inject content from [WikiPageContents](https://github.com/dataspects/mediawiki-cli/tree/main/WikiPageContents) |
| `./manage-content/inject-manage-page-from-mediawiki.org.sh` | **<span style="color: red">!</span>** Copy content from wiki A into a wiki B (e.g. from mediawiki.org) |
| `./manage-snapshots/view-restic-snapshots.sh` | <img src="https://restic.readthedocs.io/en/stable/_static/logo.png" height="20"/> [View snapshots](https://restic.readthedocs.io/en/stable/045_working_with_repos.html) |
| `./manage-snapshots/take-restic-snapshot.sh` | <img src="https://restic.readthedocs.io/en/stable/_static/logo.png" height="20"/> [Take snapshot](https://restic.readthedocs.io/en/stable/040_backup.html) |
| `./manage-snapshots/restore-restic-snapshot.sh` | <img src="https://restic.readthedocs.io/en/stable/_static/logo.png" height="20"/> [Restore snapshot](https://restic.readthedocs.io/en/stable/050_restore.html) |
| `./manage-snapshots/diff-restic-snapshots.sh` | <img src="https://restic.readthedocs.io/en/stable/_static/logo.png" height="20"/> [Compare snapshots](https://restic.readthedocs.io/en/stable/040_backup.html?highlight=diff#comparing-snapshots) |

## Component Logics

<figure>
<img src="images/component-logics.png" alt="dataaspects mediawiki-cli component logics">
    <figcaption>dataspects/mediawiki-cli's <a href="https://github.com/dataspects/mediawiki-cli/blob/main/manage-snapshots/view-restic-snapshots.sh">view-restic-snapshots</a></figcaption>
</figure>

## Snapshots

<figure>
<img src="images/snapshots.png" alt="dataaspects mediawiki-cli restic snapshots">
    <figcaption>dataspects/mediawiki-cli's <a href="https://github.com/dataspects/mediawiki-cli/blob/main/manage-snapshots/view-restic-snapshots.sh">view-restic-snapshots</a></figcaption>
</figure>