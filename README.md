# restic snapshot management for Canasta MediaWikis

This repository contains BASH wrappers for managing restic snapshots of Canasta MediaWikis, see https://canasta.wiki.

* https://restic.net
* The current version is configured for using AWS S3 based repositories.
* It uses restic's [dockerized binary](https://hub.docker.com/r/restic/restic)

## How to use

1. Add these environment variables to your Canasta's `.env`
```
AWS_S3_API=s3.amazonaws.com
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_S3_BUCKET=
RESTIC_PASSWORD=
```
2. Clone this repo onto your Canasta server
3. Use the scripts providing `CANASTA_ROOT=/path/to/your/Canasta-DockerCompose`
```
export CANASTA_ROOT=/path/to/your/Canasta-DockerCompose
./view-restic-snapshots.sh
```
or
```
CANASTA_ROOT=/path/to/your/Canasta-DockerCompose ./view-restic-snapshots.sh
```
