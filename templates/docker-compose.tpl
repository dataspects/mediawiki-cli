version: "3.7"
services:
  mariadb:
    image: mariadb:10.5.12
    container_name: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mysqlrootpassword
    volumes:
      - mariadb_data:/var/lib/mysql
  mediawiki:
    image: dataspects/mediawiki:1.35.0-2104141705
    container_name: mediawiki
    restart: always
    depends_on:
      - mariadb
    environment:
      MYSQL_HOST: mariadb
      MYSQL_USER: mediawiki
      WG_DB_PASSWORD: wgdbpassword
      DATABASE_NAME: mediawiki
    volumes:
      - etc:/var/www/html/etc
      - mediawiki_root:/var/www/html/w
      - apache_sites_available:/etc/apache2/sites-available
    ports:
      - 8080:80
volumes:
  mariadb_data:
    driver: local
  etc:
    driver: local
  mediawiki_root:
    driver: local
  apache_sites_available:
    driver: local