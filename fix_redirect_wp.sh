#/bin/bash
ls /home | grep -v deploy | grep -v `hostname` > list_users.txt 

Collect()
{
	echo "start collect ..."
	filename="./list_users.txt"
	while read -r line; do
		paste <(echo $line) <(cat /home/$line/domains/*/public_html/wp-config.php | grep "_data" | cut -d',' -f2 | cut -b 3- | rev | cut -c 4- | rev) <(ls /home/$line/domains/) >> out.txt
	done < "$filename"
	echo "finish collect ..."
}

Update_MySQL()
{
	echo "start update MySQL ..."
	filename="./out.txt"
	while read -r line; do
		DB=`echo $line | awk '{print $2}'`
		DOMAIN=`echo $line | awk '{print $3}'`
		mysql $DB -e "UPDATE wp_options SET option_value = 'https://$DOMAIN/' WHERE wp_options.option_id = 2;"
		mysql $DB -e "UPDATE wp_options SET option_value = 'https://$DOMAIN/' WHERE wp_options.option_id = 1;"
		mysql $DB -e "UPDATE wp_options SET option_value = 'anhnd.dropship@gmail.com' WHERE wp_options.option_id = 6;"
	done < "$filename"
	mysql -e "flush privileges;"
	echo "finish update MySQL ..."
}

Update_Plugin()
{
	echo "start update Plugin ..."
	/usr/bin/wget https://downloads.wordpress.org/plugin/woocommerce.5.6.0.zip
	/usr/bin/unzip woocommerce.5.6.0.zip
	filename="./out.txt"
	while read -r line; do
		USER=`echo $line | awk '{print $1}'`
		DOMAIN=`echo $line | awk '{print $3}'`
		yes | cp -rf woocommerce/* /home/$USER/domains/$DOMAIN/public_html/wp-content/plugins/woocommerce/
		chown $USER: -R /home/$USER/domains/$DOMAIN/public_html/wp-content/plugins/woocommerce/
	done < "$filename"
	echo "finish update Plugin ..."
}

Collect
Update_MySQL
Update_Plugin

