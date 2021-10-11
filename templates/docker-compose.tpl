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
      - /home/lex/mediawiki-cli/shared:/var/www/html/shared
    ports:
      - $MEDIAWIKI_PORT:8080
volumes:
  mariadb_data:
    driver: local