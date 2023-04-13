#!/bin/bash

rclone_profile=$1
date_source=$2
date_db=$3

input="listdomains.txt"

download() {
    while IFS= read -r domain
    do
        dbname=`echo $domain | head -c6`
        for fol in `rclone lsd ${rclone_profile}: | awk '{print $5}'`;do
            rclone ls ${rclone_profile}:${fol}/$date_source/${domain}.zip
            if [[ $? -eq 0 ]]; then
                echo "download source code ..."
                rclone copy ${rclone_profile}:${fol}/$date_source/${domain}.zip /tmp
                echo "download db ..."
                rclone copy ${rclone_profile}:${fol}/${date_db}/ /tmp --include ${dbname}*.gz
            fi
        done    
    done < "$input"
}

restore() {
    while IFS= read -r domain; do
        dbname=`echo $domain | head -c6`
        path=`find /home -name "$domain"`/public_html
        user=`find /home -name "$domain" | awk -F '/' '{print $3}'`
        wp_user=`cat $path/wp-config.php | grep 'DB_USER' | awk -F',' '{print $2}' | cut -c 3- | rev | cut -c 4- | rev`
        wp_data_name=`cat $path/wp-config.php | grep 'DB_NAME' | awk -F',' '{print $2}' | cut -c 3- | rev | cut -c 4- | rev`
        wp_pass=`cat $path/wp-config.php | grep 'DB_PASSWORD' | awk -F',' '{print $2}' | cut -c 3- | rev | cut -c 4- | rev`

        #move file to public_html
        cd $path/
        sudo mv wp-config.php ..
        sudo rm -rf $path/*
        mv /tmp/${domain}.zip $path/
        mv /tmp/${dbname}*.gz $path/
        #unzip
        sudo unzip ${domain}.zip
        sudo gunzip ${dbname}*.gz
        sudo mv home/*/*/*/public_html/* .
        sudo mysql $wp_data_name < ${dbname}*_data

        sudo sed -i "s/'DB_NAME', .*/'DB_NAME', '${wp_data_name}');/g" wp-config.php
        sudo sed -i "s/'DB_USER', .*/'DB_USER', '${wp_user}');/g" wp-config.php
        sudo sed -i "s/'DB_PASSWORD', .*/'DB_PASSWORD', '${wp_pass}');/g" wp-config.php
        sudo chown $user:$user -R *
        sudo rm -rf $path/${domain}.zip
        cd $path/wp-content/
        sudo rm -rf advanced-cache.php cache wp-rocket-config

    done < "$input"
}

download
restore
