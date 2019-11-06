#!/bin/bash
#Usage: ./wp_filter_email.sh [Database_name]
# with variable Database_name is list in DB using `mysql -e "show databases;"` to show list.
DBNAME=$1

mysql -D $DBNAME -e "select meta_value from wp_usermeta where meta_value REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,63}$';" > email_filter.txt

mysql -D $DBNAME -e "select post_title from wp_posts where post_title REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,63}$';" >> email_filter.txt

mysql -D $DBNAME -e "select meta_value from wp_postmeta where meta_value REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,63}$';" >> email_filter.txt

mysql -D $DBNAME -e "select comment_author_email from wp_comments where comment_author_email REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,63}$';" >> email_filter.txt

mysql -D $DBNAME -e "select user_email from wp_users where user_email REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,63}$';" >> email_filter.txt

mysql -D $DBNAME -e "select form_value from wp_db7_forms where form_value LIKE '%@%';" >> email_filter.txt
