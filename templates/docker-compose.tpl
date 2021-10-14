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
  ${MEDIAWIKI_CONTAINER_NAME}:
    image: $MEDIAWIKI_CONTAINER_IMAGE
    container_name: ${MEDIAWIKI_CONTAINER_NAME}
    restart: always
    depends_on:
      - mariadb
    volumes:
      - /home/lex/mediawiki-cli/shared:/var/www/shared
      - mediawiki0_config:/var/www/config
      - mediawiki0_extensions:/var/www/html/w/extensions
      - mediawiki0_skins:/var/www/html/w/skins
      - mediawiki0_vendor:/var/www/html/w/vendor
      - mediawiki0_images:/var/www/html/w/images
    environment:
      - AWS_S3_API=http://192.168.1.36:9000
      - AWS_ACCESS_KEY_ID=snoopy-mediawiki0
      - AWS_SECRET_ACCESS_KEY=globi2000
      - AWS_S3_BUCKET=snoopy-mediawiki0
      - RESTIC_PASSWORD=globi2000
      - MYSQL_PASSWORD=mediawikipass
      - DATABASE_NAME=mediawiki
      - MYSQL_USER=mediawiki
      - MYSQL_HOST=mariadb
    ports:
      - $MEDIAWIKI_PORT:8080
volumes:
  mariadb_data:
    driver: local
    name: mariadb_data
  mediawiki0_config:
    driver: local
    name: mediawiki0_config
  mediawiki0_extensions:
    driver: local
    name: mediawiki0_extensions
  mediawiki0_skins:
    driver: local
    name: mediawiki0_skins
  mediawiki0_vendor:
    driver: local
    name: mediawiki0_vendor
  mediawiki0_images:
    driver: local
    name: mediawiki0_images