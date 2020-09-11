#!/bin/bash

###
#cat lists.txt
#web1_data, web1_user, password1
#web2_data, web2_user, password2
#web3_data, web3_user, password3
###

input='lists.txt'
while IFS= read -r line
do
  #echo "$line"
	DB=`echo $line | awk -F " | " '{print $1}'`
	USER=`echo $line | awk -F " | " '{print $3}'`
	PW=`echo $line | awk -F " | " '{print $5}'`
	echo "$DB, $USER, $PW"
        mysql -e "drop user '$USER'@'localhost';"
	mysql -e "grant all privileges on $DB.* to '$USER'@'localhost' identified by '$PW'";
done < "$input"

mysql -e "flush privileges;"
