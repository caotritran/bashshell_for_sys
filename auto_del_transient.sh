#script delete transient on wordpress
#The Transients API is very similar to the Options API but with the added feature of an expiration time, 
which simplifies the process of using the wp_options database table to temporarily store cached information.

DBNAME="thuckhuya_data"
DBUSER="thuckhuya_user"
DBPASSWD="thuckhuya123"
MYSQLBIN=/usr/bin/mysql # OR MYSQLBIN=/usr/local/mysql/bin/mysql
MYSQL="${MYSQLBIN} -s -D ${DBNAME} -u ${DBUSER} -p${DBPASSWD}"
#MYSQL="mysql"
TMP=/var/tmp/
ENTRIES_FILE="${TMP}entries.$$"

${MYSQL} <<'EOF'
DELETE FROM `liathia_options` WHERE `option_name` LIKE ('_transient_%');
DELETE FROM `liathia_options` WHERE `option_name` LIKE ('_site_transient_%');
exit
EOF
