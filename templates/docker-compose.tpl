version: "3.7"
services:
  mariadb:
    image: $MARIADB_IMAGE
    container_name: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD
    volumes:
      - mariadb_data:/var/lib/mysql
  $MEDIAWIKI_CONTAINER_NAME:
    image: $MEDIAWIKI_CONTAINER_IMAGE
    container_name: $MEDIAWIKI_CONTAINER_NAME
    restart: always
    depends_on:
      - mariadb
    volumes:
      - /home/lex/mediawiki-cli/shared:/var/www/shared
      - /home/lex/mediawiki-cli/restic_password:/var/www/restic_password
      - $MEDIAWIKI_CONTAINER_NAME:/var/www/html
      - ${MEDIAWIKI_CONTAINER_NAME}_currentresources:/var/www/currentresources
      - ${MEDIAWIKI_CONTAINER_NAME}_snapshots:/var/www/snapshots
    ports:
      - $MEDIAWIKI_PORT:8080
volumes:
  mariadb_data:
    driver: local
    name: mariadb_data
  $MEDIAWIKI_CONTAINER_NAME:
    driver: local
    name: $MEDIAWIKI_CONTAINER_NAME
  ${MEDIAWIKI_CONTAINER_NAME}_snapshots:
    driver: local
    name: ${MEDIAWIKI_CONTAINER_NAME}_snapshots
  ${MEDIAWIKI_CONTAINER_NAME}_currentresources:
    driver: local
    name: ${MEDIAWIKI_CONTAINER_NAME}_currentresources